Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3EGIlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab3EGIlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:41:16 -0400
Date: Tue, 7 May 2013 10:42:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130507084241.GA1581@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
 <20130506123805.GA1602@redhat.com>
 <20130506083759.556dac76@chukar.edge2.net>
 <20130506153044.GB1602@redhat.com>
 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367855046.8434.16.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:44:06PM +0200, Johannes Berg wrote:
> On Mon, 2013-05-06 at 17:31 +0200, Johannes Berg wrote:
> 
> > > But if so, I would also see
> > > the breakage on my setup, but I don't - it works quite well here. 
> > 
> > Are you testing on a passive channel? Try with a large beacon interval.
> 
> I think most likely what happens is that it's on a passive channel, and
> the firmware drops the TX packet with a bad status. Before the patch,
> we'd just wait sitting on the channel for HZ/5 (200ms) before trying
> again, with the patch we immediately retransmit the packet, which will
> fail again and again until the firmware received a beacon.
> 
> If you look at iwlwifi/dvm/, it has some passive_no_rx workaround for
> this, which I don't see in iwlegacy.

Can you explain why it is named passive_no_rx instead passive_no_tx ?

> I think the best way to solve this would be to do such a thing in
> iwlegacy as well, but until then and for stable maybe we should
> introduce another HW flag to restore the previous mac80211 behaviour?

I'm not sure if I like to add passive_no_rx to iwlegacy. Stopping queues
and waiting for beacon looks sticky, what happen if beacon will not be
received?

Perhaps I will just remove IEEE80211_HW_REPORTS_TX_ACK_STATUS from 4965,
it's simpler workaround ?

Stanislaw
