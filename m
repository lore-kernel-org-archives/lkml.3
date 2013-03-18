Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3CRPW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:22:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab3CRPWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:22:25 -0400
Date: Mon, 18 Mar 2013 16:22:24 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] migrate: make core migration code aware of hugepage
Message-ID: <20130318152224.GQ10192@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361475708-25991-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-02-13 14:41:41, Naoya Horiguchi wrote:
[...]
> diff --git v3.8.orig/include/linux/mempolicy.h v3.8/include/linux/mempolicy.h
> index 0d7df39..2e475b5 100644
> --- v3.8.orig/include/linux/mempolicy.h
> +++ v3.8/include/linux/mempolicy.h
> @@ -173,7 +173,7 @@ extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
>  /* Check if a vma is migratable */
>  static inline int vma_migratable(struct vm_area_struct *vma)
>  {
> -	if (vma->vm_flags & (VM_IO | VM_HUGETLB | VM_PFNMAP))
> +	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
>  		return 0;

Is this safe? At least check_*_range don't seem to be hugetlb aware.

-- 
Michal Hocko
SUSE Labs
