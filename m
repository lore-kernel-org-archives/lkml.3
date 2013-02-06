Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3BFEYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:24:08 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52105 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab3BFEYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:24:02 -0500
MIME-Version: 1.0
In-Reply-To: <1360119136.8356.4.camel@lorien2>
References: <1360119136.8356.4.camel@lorien2>
Date: Tue, 5 Feb 2013 20:24:01 -0800
X-Google-Sender-Auth: UpaYngcIg1w_AMnvEksZq4psSkA
Message-ID: <CAE9FiQVYLb0w8N6tNNTDNyZNXF+938iax5qXFNCQz9ET3Gob3g@mail.gmail.com>
Subject: Re: [PATCH linux-next] x86/mm: Fix compile warning in remove_pagetable()
From: Yinghai Lu <yinghai@kernel.org>
To: shuah.khan@hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        hpa@zytor.com, mingo@redhat.com, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, shuahkhan@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:52 PM, Shuah Khan <shuah.khan@hp.com> wrote:
> Fix the following compile warning in remove_pagetable():
> arch/x86/mm/init_64.c: In function ‘remove_pagetable’:
> arch/x86/mm/init_64.c:996:9: warning: ‘next’ may be used uninitialized in this function [-Wuninitialized]
>
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/x86/mm/init_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 67bad4b..ed78400 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -987,7 +987,7 @@ remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
>  static void __meminit
>  remove_pagetable(unsigned long start, unsigned long end, bool direct)
>  {
> -       unsigned long next;
> +       unsigned long next = pgd_addr_end(start, end);
>         pgd_t *pgd;
>         pud_t *pud;
>         bool pgd_changed = false;
> --
> 1.7.9.5

Andrew already had one fix-fix-...-fix for that.



On Mon, Feb 4, 2013 at 3:28 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 4 Feb 2013 15:18:58 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Mon, Feb 4, 2013 at 3:04 PM,  <akpm@linux-foundation.org> wrote:
>> >
>> > The patch titled
>> >      Subject: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix
>> > has been added to the -mm tree.  Its filename is
>> >      memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
>> >
>> > Before you just go and hit "reply", please:
>> >    a) Consider who else should be cc'ed
>> >    b) Prefer to cc a suitable mailing list as well
>> >    c) Ideally: find the original patch on the mailing list and do a
>> >       reply-to-all to that, adding suitable additional cc's
>> >
>> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
>> >
>> > The -mm tree is included into linux-next and is updated
>> > there every 3-4 working days
>> >
>> > ------------------------------------------------------
>> > From: Andrew Morton <akpm@linux-foundation.org>
>> > Subject: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix
>> >
>> > fix used-uninitialised bug
>> >
>> > Cc: Jiang Liu <jiang.liu@huawei.com>
>> > Cc: Jianguo Wu <wujianguo@huawei.com>
>> > Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
>> > Cc: Tang Chen <tangchen@cn.fujitsu.com>
>> > Cc: Wen Congyang <wency@cn.fujitsu.com>
>> > Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> > Cc: Yinghai Lu <yinghai@kernel.org>
>> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> > ---
>> >
>> >  arch/x86/mm/init_64.c |    4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff -puN arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix arch/x86/mm/init_64.c
>> > --- a/arch/x86/mm/init_64.c~memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix
>>
>> it is hard to count fix now!
>
> Yes, I think that's a world record ;)
>
>> > +++ a/arch/x86/mm/init_64.c
>> > @@ -993,12 +993,12 @@ remove_pagetable(unsigned long start, un
>> >         bool pgd_changed = false;
>> >
>> >         for (; start < end; start = next) {
>> > +               next = pgd_addr_end(start, end);
>> > +
>> >                 pgd = pgd_offset_k(start);
>> >                 if (!pgd_present(*pgd))
>> >                         continue;
>> >
>> > -               next = pgd_addr_end(start, end);
>> > -
>> >                 pud = (pud_t *)pgd_page_vaddr(*pgd);
>> >                 remove_pud_table(pud, start, next, direct);
>> >                 if (free_pud_table(pud, pgd))
>> > _
>>
>> It's a real bug fix.
>> Without this fix, it will get dead loop if there is 512G (and aligned)
>> memory hole in the range.
>
> OK, thanks.
