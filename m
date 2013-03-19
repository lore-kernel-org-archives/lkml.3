Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3CSLBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3CSLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:01:41 -0400
Date: Tue, 19 Mar 2013 11:01:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
Message-ID: <20130319110137.GK2055@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-4-git-send-email-mgorman@suse.de>
 <5147D6A7.5060008@gmail.com>
 <20130319101428.GD2055@suse.de>
 <51483D63.4070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51483D63.4070904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 06:26:43PM +0800, Simon Jeons wrote:
> >>>-		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
> >>>-			break;
> >>>-	} while (--sc.priority >= 0);
> >>>+		if (order && sc.nr_reclaimed >= 2UL << order)
> >>>+			order = sc.order = 0;
> >>If order == 0 is meet, should we do defrag for it?
> >>
> >Compaction is unnecessary for order-0.
> >
> 
> I mean since order && sc.reclaimed >= 2UL << order, it is reclaimed
> for high order allocation, if order == 0 is meet, should we do
> defrag for it?
> 

I don't get this question at all. We do not defrag via compaction for
order-0 allocation requests because it makes no sense.

-- 
Mel Gorman
SUSE Labs
