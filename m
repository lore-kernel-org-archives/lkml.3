Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3CUSHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:07:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab3CUSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:07:38 -0400
Date: Thu, 21 Mar 2013 18:07:35 +0000
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] mm: vmscan: Check if kswapd should writepage once
 per priority
Message-ID: <20130321180735.GN1878@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-10-git-send-email-mgorman@suse.de>
 <20130321165600.GV6094@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130321165600.GV6094@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 05:58:37PM +0100, Michal Hocko wrote:
> On Sun 17-03-13 13:04:15, Mel Gorman wrote:
> > Currently kswapd checks if it should start writepage as it shrinks
> > each zone without taking into consideration if the zone is balanced or
> > not. This is not wrong as such but it does not make much sense either.
> > This patch checks once per priority if kswapd should be writing pages.
> 
> Except it is not once per priority strictly speaking...  It doesn't make
> any difference though.
> 

Whoops, at one point during development it really was once per priority
which was always raised. I reworded it to "once per pgdat scan".

Thanks.

-- 
Mel Gorman
SUSE Labs
