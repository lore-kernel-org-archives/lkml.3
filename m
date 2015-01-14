Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbANQul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:50:41 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54152 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbANQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:50:40 -0500
Date: Wed, 14 Jan 2015 17:50:36 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vinayak Menon <vinmenon@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov@parallels.com,
        mgorman@suse.de, minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150114165036.GI4706@dhcp22.suse.cz>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-01-15 17:06:59, Vinayak Menon wrote:
[...]
> In one such instance, zone_page_state(zone, NR_ISOLATED_FILE)
> had returned 14, zone_page_state(zone, NR_INACTIVE_FILE)
> returned 92, and GFP_IOFS was set, and this resulted
> in too_many_isolated returning true. But one of the CPU's
> pageset vm_stat_diff had NR_ISOLATED_FILE as "-14". So the
> actual isolated count was zero. As there weren't any more
> updates to NR_ISOLATED_FILE and vmstat_update deffered work
> had not been scheduled yet, 7 tasks were spinning in the
> congestion wait loop for around 4 seconds, in the direct
> reclaim path.

Not syncing for such a long time doesn't sound right. I am not familiar
with the vmstat syncing but sysctl_stat_interval is HZ so it should
happen much more often that every 4 seconds.

-- 
Michal Hocko
SUSE Labs
