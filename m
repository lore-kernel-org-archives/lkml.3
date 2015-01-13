Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbbAMQJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:09:48 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57298 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbbAMQJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:09:46 -0500
Date: Tue, 13 Jan 2015 11:09:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vinayak Menon <vinmenon@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, vdavydov@parallels.com, mhocko@suse.cz,
        mgorman@suse.de, minchan@kernel.org
Subject: Re: [PATCH] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150113160940.GD8180@phnom.home.cmpxchg.org>
References: <1421147247-10870-1-git-send-email-vinmenon@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421147247-10870-1-git-send-email-vinmenon@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:37:27PM +0530, Vinayak Menon wrote:
> @@ -1392,6 +1392,44 @@ int isolate_lru_page(struct page *page)
>  	return ret;
>  }
>  
> +static int __too_many_isolated(struct zone *zone, int file,
> +	struct scan_control *sc, int safe)
> +{
> +	unsigned long inactive, isolated;
> +
> +	if (file) {
> +		if (safe) {
> +			inactive = zone_page_state_snapshot(zone,
> +					NR_INACTIVE_FILE);
> +			isolated = zone_page_state_snapshot(zone,
> +					NR_ISOLATED_FILE);
> +		} else {
> +			inactive = zone_page_state(zone, NR_INACTIVE_FILE);
> +			isolated = zone_page_state(zone, NR_ISOLATED_FILE);
> +		}
> +	} else {
> +		if (safe) {
> +			inactive = zone_page_state_snapshot(zone,
> +					NR_INACTIVE_ANON);
> +			isolated = zone_page_state_snapshot(zone,
> +					NR_ISOLATED_ANON);
> +		} else {
> +			inactive = zone_page_state(zone, NR_INACTIVE_ANON);
> +			isolated = zone_page_state(zone, NR_ISOLATED_ANON);
> +		}
> +	}

	if (safe) {
		inactive = zone_page_state_snapshot(zone, NR_INACTIVE_ANON + 2*file)
		isolated = zone_page_state_snapshot(zone, NR_ISOLATED_ANON + file)
	} else {
		inactive = zone_page_state(zone, NR_INACTIVE_ANON + 2*file)
		isolated = zone_page_state(zone, NR_ISOLATED_ANON + file)
	}
