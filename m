Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3KAGZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3KAGZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:25:02 -0400
Date: Fri, 01 Nov 2013 02:23:44 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Message-ID: <1383287024-o4iedqct-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1383169499-25144-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1383169499-25144-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1383169499-25144-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 01/11] pagewalk: update page table walker core
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1383169499-25144-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 05:44:49PM -0400, Naoya Horiguchi wrote:
...
> diff --git v3.12-rc7-mmots-2013-10-29-16-24.orig/mm/pagewalk.c v3.12-rc7-mmots-2013-10-29-16-24/mm/pagewalk.c
> index 2beeabf..af93846 100644
> --- v3.12-rc7-mmots-2013-10-29-16-24.orig/mm/pagewalk.c
> +++ v3.12-rc7-mmots-2013-10-29-16-24/mm/pagewalk.c
> @@ -3,29 +3,49 @@
>  #include <linux/sched.h>
>  #include <linux/hugetlb.h>
>  
> -static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> -			  struct mm_walk *walk)
> +static inline bool skip_check(mm_walk *walk)

Sorry, I missed 'struct' here.
It happened to be lost in my squashing patches.
