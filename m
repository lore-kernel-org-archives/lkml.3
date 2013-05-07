Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3EGPeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3EGPd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:33:58 -0400
Date: Tue, 7 May 2013 17:35:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130507153525.GB1576@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
 <20130506123805.GA1602@redhat.com>
 <20130506083759.556dac76@chukar.edge2.net>
 <20130506153044.GB1602@redhat.com>
 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
 <20130507084241.GA1581@redhat.com>
 <1367934810.8328.30.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367934810.8328.30.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 03:53:30PM +0200, Johannes Berg wrote:
> > > I think the best way to solve this would be to do such a thing in
> > > iwlegacy as well, but until then and for stable maybe we should
> > > introduce another HW flag to restore the previous mac80211 behaviour?
> > 
> > I'm not sure if I like to add passive_no_rx to iwlegacy. Stopping queues
> > and waiting for beacon looks sticky, what happen if beacon will not be
> > received?
> 
> Good question, do we get stuck? I was assuming we'd time out, but maybe
> that's not the case?

AFICT, we wake queues only if beacon arrives or mac80211 call drv_config
with BSS_CHANGED_IDLE. I'm not sure if the latter prevent stuck. 

> > Perhaps I will just remove IEEE80211_HW_REPORTS_TX_ACK_STATUS from 4965,
> > it's simpler workaround ?
> 
> Sure, but maybe that loses other semantics that you want?
> 
> And anyway it's not complete. If you have a very long beacon interval
> (say 1 second) then this could still lead to all probe/auth retries
> going out inbetween two beacons since the timeout is just 3*100ms.

Let's make that change as temporary regression workaround, I'll add
passive_no_rx workaround latter. I'll also think if it can stuck or
not.

Stanislaw
