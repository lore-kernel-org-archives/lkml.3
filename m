Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3CUM4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:56:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3CUM4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:56:33 -0400
Date: Thu, 21 Mar 2013 13:56:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] extend hugepage migration
Message-ID: <20130321125628.GB6051@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <5148F830.3070601@gmail.com>
 <1363815326-urchkyxr-mutt-n-horiguchi@ah.jp.nec.com>
 <514A4B1C.6020201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514A4B1C.6020201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-03-13 07:49:48, Simon Jeons wrote:
[...]
> When I hacking arch/x86/mm/hugetlbpage.c like this,
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index ae1aa71..87f34ee 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -354,14 +354,13 @@ hugetlb_get_unmapped_area(struct file *file,
> unsigned long addr,
> 
> #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
> 
> -#ifdef CONFIG_X86_64
> static __init int setup_hugepagesz(char *opt)
> {
> unsigned long ps = memparse(opt, &opt);
> if (ps == PMD_SIZE) {
> hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
> - } else if (ps == PUD_SIZE && cpu_has_gbpages) {
> - hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
> + } else if (ps == PUD_SIZE) {
> + hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT+4);
> } else {
> printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
> ps >> 20);
> 
> I set boot=hugepagesz=1G hugepages=10, then I got 10 32MB huge pages.
> What's the difference between these pages which I hacking and normal
> huge pages?

How is this related to the patch set?
Please _stop_ distracting discussion to unrelated topics!

Nothing personal but this is just wasting our time.
-- 
Michal Hocko
SUSE Labs
