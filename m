Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3CYPMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:12:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab3CYPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:12:48 -0400
Date: Mon, 25 Mar 2013 16:12:46 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] prepare to remove
 /proc/sys/vm/hugepages_treat_as_movable
Message-ID: <20130325151246.GB2154@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-11-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363983835-20184-11-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-03-13 16:23:55, Naoya Horiguchi wrote:
[...]
> @@ -2086,11 +2085,7 @@ int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
>  			void __user *buffer,
>  			size_t *length, loff_t *ppos)
>  {
> -	proc_dointvec(table, write, buffer, length, ppos);
> -	if (hugepages_treat_as_movable)
> -		htlb_alloc_mask = GFP_HIGHUSER_MOVABLE;
> -	else
> -		htlb_alloc_mask = GFP_HIGHUSER;
> +	/* hugepages_treat_as_movable is obsolete and to be removed. */

WARN_ON_ONCE("This knob is obsolete and has no effect. It is scheduled for removal")
>  	return 0;
>  }
>  
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
