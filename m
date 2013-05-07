Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab3EGNxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:53:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:54421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab3EGNxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:53:37 -0400
Message-ID: <1367934810.8328.30.camel@jlt4.sipsolutions.net>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 07 May 2013 15:53:30 +0200
In-Reply-To: <20130507084241.GA1581@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 <20130506123805.GA1602@redhat.com>
	 <20130506083759.556dac76@chukar.edge2.net>
	 <20130506153044.GB1602@redhat.com>
	 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
	 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
	 <20130507084241.GA1581@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 10:42 +0200, Stanislaw Gruszka wrote:

> Can you explain why it is named passive_no_rx instead passive_no_tx ?

Emmanuel already commented on this, basically the error codes are all
for "I couldn't transmit this frame", so here we have "I couldn't
transmit this frame because it was on a _passive_ channel and there was
_no rx_ yet."

> > I think the best way to solve this would be to do such a thing in
> > iwlegacy as well, but until then and for stable maybe we should
> > introduce another HW flag to restore the previous mac80211 behaviour?
> 
> I'm not sure if I like to add passive_no_rx to iwlegacy. Stopping queues
> and waiting for beacon looks sticky, what happen if beacon will not be
> received?

Good question, do we get stuck? I was assuming we'd time out, but maybe
that's not the case?

> Perhaps I will just remove IEEE80211_HW_REPORTS_TX_ACK_STATUS from 4965,
> it's simpler workaround ?

Sure, but maybe that loses other semantics that you want?

And anyway it's not complete. If you have a very long beacon interval
(say 1 second) then this could still lead to all probe/auth retries
going out inbetween two beacons since the timeout is just 3*100ms.

johannes

