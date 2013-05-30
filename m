Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968114Ab3E3KKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:10:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967701Ab3E3KKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:10:48 -0400
Date: Thu, 30 May 2013 11:10:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Reduce system disruption due to kswapd followup V3
Message-ID: <20130530101044.GB29426@suse.de>
References: <1369869457-22570-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1369869457-22570-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 12:17:29AM +0100, Mel Gorman wrote:
> tldr; Overall the system is getting less kicked in the face. Scan rates
> 	between zones is often more balanced than it used to be. There are
> 	now fewer writes from reclaim context and a reduction in IO wait
> 	times.
> 
> This series replaces all of the previous follow-up series. It was clear
> that more of the stall logic needed to be in the same place so it is
> comprehensible and easier to predict.
> 

There was some unfortunate crossover in timing as I see mmotm has pulled
in the previous follow up series. It would probably be easiest to replace
these patches

mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch

with patches 2-8 of this series. The fixup patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
is still the same

Sorry for the inconvenience.

-- 
Mel Gorman
SUSE Labs
