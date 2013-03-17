Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3CQPkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:40:18 -0400
Received: from two.firstfloor.org ([193.170.194.197]:50940 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3CQPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:40:15 -0400
Date: Sun, 17 Mar 2013 16:40:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] mm: vmscan: Block kswapd if it is encountering
 pages under writeback
Message-ID: <20130317154013.GC20853@two.firstfloor.org>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-8-git-send-email-mgorman@suse.de>
 <m21ubejd2p.fsf@firstfloor.org>
 <20130317151917.GD2026@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317151917.GD2026@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > BTW longer term the code would probably be a lot clearer with a
> > real explicit state machine instead of all these custom state bits.
> > 
> 
> I would expect so even though it'd be a major overhawl.

A lot of these VM paths need overhaul because they usually don't
do enough page batching to perform really well on larger systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
