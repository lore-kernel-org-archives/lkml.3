Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaAXE2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:28:03 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37836 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaAXE2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:28:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140123232012.GA23046@orcus.uplinklabs.net>
References: <20140121232708.GA29787@amazon.com>
	<20140122014908.GG18164@kroah.com>
	<CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
	<20140122032045.GA22182@falcon.amazon.com>
	<20140122050215.GC9931@konrad-lan.dumpdata.com>
	<20140122072914.GA9283@orcus.uplinklabs.net>
	<52DFD5DB.6060603@iogearbox.net>
	<CAEr7rXhJf1tf2KUErsGgUyYNUpVwLYD=fKUf8aPm0Dcg21MuNQ@mail.gmail.com>
	<20140122203337.GA31908@orcus.uplinklabs.net>
	<CAEr7rXjge6rKzxbwy+0A6-5YhVZL9WGmaLrDYbE8H5hrtwq_4A@mail.gmail.com>
	<20140123232012.GA23046@orcus.uplinklabs.net>
Date: Thu, 23 Jan 2014 23:28:00 -0500
Message-ID: <CAEr7rXieOpz7sYRoAdCkh6j09cee9Bew-FcQ8gJQ9mC6dccgfQ@mail.gmail.com>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Daniel Borkmann <borkmann@iogearbox.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        George Dunlap <george.dunlap@eu.citrix.com>,
        Dario Faggioli <dario.faggioli@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 6:20 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Thu, Jan 23, 2014 at 11:23:37AM -0500, Elena Ufimtseva wrote:
>> On Wed, Jan 22, 2014 at 3:33 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> > On Wed, Jan 22, 2014 at 03:18:50PM -0500, Elena Ufimtseva wrote:
>> >> On Wed, Jan 22, 2014 at 9:29 AM, Daniel Borkmann <borkmann@iogearbox.net> wrote:
>> >> > On 01/22/2014 08:29 AM, Steven Noonan wrote:
>> >> >>
>> >> >> On Wed, Jan 22, 2014 at 12:02:15AM -0500, Konrad Rzeszutek Wilk wrote:
>> >> >>>
>> >> >>> On Tue, Jan 21, 2014 at 07:20:45PM -0800, Steven Noonan wrote:
>> >> >>>>
>> >> >>>> On Tue, Jan 21, 2014 at 06:47:07PM -0800, Linus Torvalds wrote:
>> >> >>>>>
>> >> >>>>> On Tue, Jan 21, 2014 at 5:49 PM, Greg Kroah-Hartman
>> >> >>>>> <gregkh@linuxfoundation.org> wrote:
>> >> >>>
>> >> >>>
>> >> >>> Adding extra folks to the party.
>> >> >>>>>>
>> >> >>>>>>
>> >> >>>>>> Odds are this also shows up in 3.13, right?
>> >> >>>>
>> >> >>>>
>> >> >>>> Reproduced using 3.13 on the PV guest:
>> >> >>>>
>> >> >>>>         [  368.756763] BUG: Bad page map in process mp
>> >> >>>> pte:80000004a67c6165 pmd:e9b706067
>> >> >>>>         [  368.756777] page:ffffea001299f180 count:0 mapcount:-1
>> >> >>>> mapping:          (null) index:0x0
>> >> >>>>         [  368.756781] page flags: 0x2fffff80000014(referenced|dirty)
>> >> >>>>         [  368.756786] addr:00007fd1388b7000 vm_flags:00100071
>> >> >>>> anon_vma:ffff880e9ba15f80 mapping:          (null) index:7fd1388b7
>> >> >>>>         [  368.756792] CPU: 29 PID: 618 Comm: mp Not tainted 3.13.0-ec2
>> >> >>>> #1
>> >> >>>>         [  368.756795]  ffff880e9b718958 ffff880e9eaf3cc0
>> >> >>>> ffffffff814d8748 00007fd1388b7000
>> >> >>>>         [  368.756803]  ffff880e9eaf3d08 ffffffff8116d289
>> >> >>>> 0000000000000000 0000000000000000
>> >> >>>>         [  368.756809]  ffff880e9b7065b8 ffffea001299f180
>> >> >>>> 00007fd1388b8000 ffff880e9eaf3e30
>> >> >>>>         [  368.756815] Call Trace:
>> >> >>>>         [  368.756825]  [<ffffffff814d8748>] dump_stack+0x45/0x56
>> >> >>>>         [  368.756833]  [<ffffffff8116d289>] print_bad_pte+0x229/0x250
>> >> >>>>         [  368.756837]  [<ffffffff8116eae3>]
>> >> >>>> unmap_single_vma+0x583/0x890
>> >> >>>>         [  368.756842]  [<ffffffff8116feb5>] unmap_vmas+0x65/0x90
>> >> >>>>         [  368.756847]  [<ffffffff81175dac>] unmap_region+0xac/0x120
>> >> >>>>         [  368.756852]  [<ffffffff81176379>] ? vma_rb_erase+0x1c9/0x210
>> >> >>>>         [  368.756856]  [<ffffffff81177f10>] do_munmap+0x280/0x370
>> >> >>>>         [  368.756860]  [<ffffffff81178041>] vm_munmap+0x41/0x60
>> >> >>>>         [  368.756864]  [<ffffffff81178f32>] SyS_munmap+0x22/0x30
>> >> >>>>         [  368.756869]  [<ffffffff814e70ed>]
>> >> >>>> system_call_fastpath+0x1a/0x1f
>> >> >>>>         [  368.756872] Disabling lock debugging due to kernel taint
>> >> >>>>         [  368.760084] BUG: Bad rss-counter state mm:ffff880e9d079680
>> >> >>>> idx:0 val:-1
>> >> >>>>         [  368.760091] BUG: Bad rss-counter state mm:ffff880e9d079680
>> >> >>>> idx:1 val:1
>> >> >>>>
>> >> >>>>>
>> >> >>>>> Probably. I don't have a Xen PV setup to test with (and very little
>> >> >>>>> interest in setting one up).. And I have a suspicion that it might not
>> >> >>>>> be so much about Xen PV, as perhaps about the kind of hardware.
>> >> >>>>>
>> >> >>>>> I suspect the issue has something to do with the magic _PAGE_NUMA
>> >> >>>>> tie-in with _PAGE_PRESENT. And then mprotect(PROT_NONE) ends up
>> >> >>>>> removing the _PAGE_PRESENT bit, and now the crazy numa code is
>> >> >>>>> confused.
>> >> >>>>>
>> >> >>>>> The whole _PAGE_NUMA thing is a f*cking horrible hack, and shares the
>> >> >>>>> bit with _PAGE_PROTNONE, which is why it then has that tie-in to
>> >> >>>>> _PAGE_PRESENT.
>> >> >>>>>
>> >> >>>>> Adding Andrea to the Cc, because he's the author of that horridness.
>> >> >>>>> Putting Steven's test-case here as an attachement for Andrea, maybe
>> >> >>>>> that makes him go "Ahh, yes, silly case".
>> >> >>>>>
>> >> >>>>> Also added Kirill, because he was involved the last _PAGE_NUMA debacle.
>> >> >>>>>
>> >> >>>>> Andrea, you can find the thread on lkml, but it boils down to commit
>> >> >>>>> 1667918b6483 (backported to 3.12.7 as 3d792d616ba4) breaking the
>> >> >>>>> attached test-case (but apparently only under Xen PV). There it
>> >> >>>>> apparently causes a "BUG: Bad page map .." error.
>> >> >>>
>> >> >>>
>> >> >>> I *think* it is due to the fact that pmd_numa and pte_numa is getting the
>> >> >>> _raw_
>> >> >>> value of PMDs and PTEs. That is - it does not use the pvops interface
>> >> >>> and instead reads the values directly from the page-table. Since the
>> >> >>> page-table is also manipulated by the hypervisor - there are certain
>> >> >>> flags it also sets to do its business. It might be that it uses
>> >> >>> _PAGE_GLOBAL as well - and Linux picks up on that. If it was using
>> >> >>> pte_flags that would invoke the pvops interface.
>> >> >>>
>> >> >>> Elena, Dariof and George, you guys had been looking at this a bit deeper
>> >> >>> than I have. Does the Xen hypervisor use the _PAGE_GLOBAL for PV guests?
>>
>> It does use _PAGE_GLOBAL for guest user pages
>>
>> >> >>>
>> >> >>> This not-compiled-totally-bad-patch might shed some light on what I was
>> >> >>> thinking _could_ fix this issue - and IS NOT A FIX - JUST A HACK.
>> >> >>> It does not fix it for PMDs naturally (as there are no PMD paravirt ops
>> >> >>> for that).
>> >> >>
>> >> >>
>> >> >> Unfortunately the Totally Bad Patch seems to make no difference. I am
>> >> >> still able to repro the issue:
>> >>
>> >> Steven, do you use numa=fake on boot cmd line for pv guest?
>> >>
>> >> I had similar issue on pv guest. Let me check if the fix that resolved
>> >> this for me will help with 3.13.
>> >
>> > Nope:
>> >
>> > # cat /proc/cmdline
>> > root=/dev/xvda1 ro rootwait rootfstype=ext4 nomodeset console=hvc0 earlyprintk=xen,verbose loglevel=7
>>
>> >
>> >>
>> >> >
>> >> >
>> >> > Maybe this one is also related to this BUG here (cc'ed people investigating
>> >> > this one) ...
>> >> >
>> >> >   https://lkml.org/lkml/2014/1/10/427
>> >> >
>> >> > ... not sure, though.
>> >> >
>> >> >
>> >> >>         [  346.374929] BUG: Bad page map in process mp
>> >> >> pte:80000004ae928065 pmd:e993f9067
>> >> >>         [  346.374942] page:ffffea0012ba4a00 count:0 mapcount:-1 mapping:
>> >> >> (null) index:0x0
>> >> >>         [  346.374946] page flags: 0x2fffff80000014(referenced|dirty)
>> >> >>         [  346.374951] addr:00007f06a9bbb000 vm_flags:00100071
>> >> >> anon_vma:ffff880e9939fe00 mapping:          (null) index:7f06a9bbb
>> >> >>         [  346.374956] CPU: 29 PID: 609 Comm: mp Not tainted 3.13.0-ec2+
>> >> >> #1
>> >> >>         [  346.374960]  ffff880e9cc38da8 ffff880e991a3cc0 ffffffff814d8768
>> >> >> 00007f06a9bbb000
>> >> >>         [  346.374967]  ffff880e991a3d08 ffffffff8116d289 0000000000000000
>> >> >> 0000000000000000
>> >> >>         [  346.374972]  ffff880e993f9dd8 ffffea0012ba4a00 00007f06a9bbc000
>> >> >> ffff880e991a3e30
>> >> >>         [  346.374979] Call Trace:
>> >> >>         [  346.374988]  [<ffffffff814d8768>] dump_stack+0x45/0x56
>> >> >>         [  346.374996]  [<ffffffff8116d289>] print_bad_pte+0x229/0x250
>> >> >>         [  346.375000]  [<ffffffff8116eae3>] unmap_single_vma+0x583/0x890
>> >> >>         [  346.375006]  [<ffffffff8116feb5>] unmap_vmas+0x65/0x90
>> >> >>         [  346.375011]  [<ffffffff81175dbc>] unmap_region+0xac/0x120
>> >> >>         [  346.375016]  [<ffffffff81176389>] ? vma_rb_erase+0x1c9/0x210
>> >> >>         [  346.375021]  [<ffffffff81177f20>] do_munmap+0x280/0x370
>> >> >>         [  346.375025]  [<ffffffff81178051>] vm_munmap+0x41/0x60
>> >> >>         [  346.375029]  [<ffffffff81178f42>] SyS_munmap+0x22/0x30
>> >> >>         [  346.375034]  [<ffffffff814e712d>]
>> >> >> system_call_fastpath+0x1a/0x1f
>> >> >>         [  346.375037] Disabling lock debugging due to kernel taint
>> >> >>         [  346.380082] BUG: Bad rss-counter state mm:ffff880e9d22bc00
>> >> >> idx:0 val:-1
>> >> >>         [  346.380088] BUG: Bad rss-counter state mm:ffff880e9d22bc00
>> >> >> idx:1 val:1
>> >> >>
>> >> >> This dump doesn't look dramatically different, either.
>> >> >>
>> >> >>>
>> >> >>> The other question is - how is AutoNUMA running when it is not enabled?
>> >> >>> Shouldn't those _PAGE_NUMA ops be nops when AutoNUMA hasn't even been
>> >> >>> turned on?
>> >> >>
>> >> >>
>> >> >> Well, NUMA_BALANCING is enabled in the kernel config[1], but I presume you
>> >> >> mean not enabled at runtime?
>> >> >>
>> >> >> [1]
>> >> >> http://git.uplinklabs.net/snoonan/projects/archlinux/ec2/ec2-packages.git/tree/linux-ec2/config.x86_64
>> >>
>> >>
>> >>
>> >> --
>> >> Elena
>>
>> I was able to reproduce this consistently, also with the latest mm
>> patches from yesterday.
>> Can you please try this:
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index ce563be..76dcf96 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct
>> *mm, unsigned long addr,
>>  /* Assume pteval_t is equivalent to all the other *val_t types. */
>>  static pteval_t pte_mfn_to_pfn(pteval_t val)
>>  {
>> -       if (val & _PAGE_PRESENT) {
>> +       if ((val & _PAGE_PRESENT) || ((val &
>> (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA)) {
>>                 unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>>                 unsigned long pfn = mfn_to_pfn(mfn);
>>
>> @@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
>>
>>  static pteval_t pte_pfn_to_mfn(pteval_t val)
>>  {
>> -       if (val & _PAGE_PRESENT) {
>> +       if ((val & _PAGE_PRESENT) || ((val &
>> (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA)) {
>>                 unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>>                 pteval_t flags = val & PTE_FLAGS_MASK;
>>                 unsigned long mfn;
>
> Thanks Elena, I just tested that and it does un-break things.
>
> - Steven


Good sign ) Ok, Ill format this patch for submission after it will be
clear what path is taken here (as its not numa auto balancing related
thing).
-- 
Elena
