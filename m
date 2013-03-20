Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3CTXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:49:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56411 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3CTXty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:49:54 -0400
X-Greylist: delayed 172591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 19:49:54 EDT
Message-ID: <514A4B1C.6020201@gmail.com>
Date: Thu, 21 Mar 2013 07:49:48 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] extend hugepage migration
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <5148F830.3070601@gmail.com> <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naoya,
On 03/21/2013 05:35 AM, Naoya Horiguchi wrote:
> On Wed, Mar 20, 2013 at 07:43:44AM +0800, Simon Jeons wrote:
> ...
>>> Easy patch access:
>>>   git@github.com:Naoya-Horiguchi/linux.git
>>>   branch:extend_hugepage_migration
>>>
>>> Test code:
>>>   git@github.com:Naoya-Horiguchi/test_hugepage_migration_extension.git
>> git clone
>> git@github.com:Naoya-Horiguchi/test_hugepage_migration_extension.git
>> Cloning into test_hugepage_migration_extension...
>> Permission denied (publickey).
>> fatal: The remote end hung up unexpectedly
> Sorry, wrong url.
> git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git
> or
> https://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git
> should work.

When I hacking arch/x86/mm/hugetlbpage.c like this,
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index ae1aa71..87f34ee 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -354,14 +354,13 @@ hugetlb_get_unmapped_area(struct file *file,
unsigned long addr,

#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/

-#ifdef CONFIG_X86_64
static __init int setup_hugepagesz(char *opt)
{
unsigned long ps = memparse(opt, &opt);
if (ps == PMD_SIZE) {
hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
- } else if (ps == PUD_SIZE && cpu_has_gbpages) {
- hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+ } else if (ps == PUD_SIZE) {
+ hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT+4);
} else {
printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
ps >> 20);

I set boot=hugepagesz=1G hugepages=10, then I got 10 32MB huge pages.
What's the difference between these pages which I hacking and normal
huge pages?

>
> Thanks,
> Naoya

