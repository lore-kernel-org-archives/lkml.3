Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaBJP2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:28:36 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46140 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaBJP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:28:32 -0500
Date: Mon, 10 Feb 2014 16:28:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] memcg: sanitize __mem_cgroup_try_charge() call
 protocol
Message-ID: <20140210152829.GL7117@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
 <1391792665-21678-9-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-9-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 12:04:25, Johannes Weiner wrote:
> Some callsites pass a memcg directly, some callsites pass a mm that
> first has to be translated to an mm.  This makes for a terrible
> function interface.
> 
> Just push the mm-to-memcg translation into the respective callsites
> and always pass a memcg to mem_cgroup_try_charge().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

OK if you really think that repeating the same pattern when charging
against mm is better then I can live with that. It is a trivial amount
of code.

[...]
> @@ -3923,21 +3895,17 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  	 */
>  	if (PageCgroupUsed(pc))
>  		return 0;

I think that we should set *memcgp in this path rather than rely on
caller to do the right thing. Both current callers do so but it is not
nice. And the detail why we need NULL is quite subtle so a comment
mentioning that __mem_cgroup_commit_charge_swapin has to ignore such a
page would be more than welcome.
[...]

Other than that looks good to me.
-- 
Michal Hocko
SUSE Labs
