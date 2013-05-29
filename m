Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935304Ab3E2W3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:29:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935301Ab3E2W3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:29:03 -0400
Date: Thu, 30 May 2013 00:28:58 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: vmscan: Take page buffers dirty and locked state
 into account
Message-ID: <20130529222858.GB22837@quack.suse.cz>
References: <1369659778-6772-1-git-send-email-mgorman@suse.de>
 <1369659778-6772-5-git-send-email-mgorman@suse.de>
 <20130529125356.5018cb1ba28959664be67791@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529125356.5018cb1ba28959664be67791@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-05-13 12:53:56, Andrew Morton wrote:
> On Mon, 27 May 2013 14:02:58 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > Page reclaim keeps track of dirty and under writeback pages and uses it to
> > determine if wait_iff_congested() should stall or if kswapd should begin
> > writing back pages. This fails to account for buffer pages that can be under
> > writeback but not PageWriteback which is the case for filesystems like ext3
> > ordered mode. Furthermore, PageDirty buffer pages can have all the buffers
> > clean and writepage does no IO so it should not be accounted as congested.
> 
> iirc, the PageDirty-all-buffers-clean state is pretty rare.  It might
> not be worth bothering about?
  Not true for ext3 in data=ordered mode. In some workloads, kjournald ends
up writing most of the data during journal commit and that exactly leaves
dirty pages with clean buffers. So in such setup lots of dirty pages can be
of that strange kind...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
