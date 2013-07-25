Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3GYH60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:58:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:53329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:58:24 -0400
Message-ID: <1374739101.8827.7.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: use oneshot blink API for LED triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 09:58:21 +0200
In-Reply-To: <20130724085337.GA7096@balto.lan> (sfid-20130724_105341_536708_82A83A0A)
References: <1374624581-6012-1-git-send-email-fabio.baltieri@gmail.com>
	 <1374624581-6012-2-git-send-email-fabio.baltieri@gmail.com>
	 <1374653665.8180.0.camel@jlt4.sipsolutions.net>
	 <20130724085337.GA7096@balto.lan> (sfid-20130724_105341_536708_82A83A0A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 10:53 +0200, Fabio Baltieri wrote:
> On Wed, Jul 24, 2013 at 10:14:25AM +0200, Johannes Berg wrote:
> > On Wed, 2013-07-24 at 02:09 +0200, Fabio Baltieri wrote:
> > > Changes mac80211 LED trigger code to use the generic
> > > led_trigger_blink_oneshot() API for transmit and receive activity
> > > indication.
> > > 
> > > This gives a better feedback to the user, as with the new API each
> > > activity event results in a visible blink, while a constant traffic
> > > results in a continuous blink at constant rate.
> > 
> > This seems a little pointless since our throughput-based trigger can do
> > very similar (but somewhat better) behaviour? Maybe that should just be
> > the default instead, with some sane default setup values?
> 
> Ok but that requires driver specific support and it's only implemented
> on a subset of currently available drivers.

Not necessarily, it's just done that way because we expected everyone to
have their own idea of what the blink speeds should be, possibly even
depending on the maximum speed the hardware can do etc.

> This at least makes the basic tx/rx indication capability a better.

Fair enough.

> > (Regardless of that, you also have indentation problems in your patch)
> 
> Ok, I guess you are referring to the this:
> 
> +       led_trigger_blink_oneshot(local->tx_led,                                
> +                       &led_delay, &led_delay, 0);                             

Yes, that was the place I noticed, didn't check more closely.

> So, are you definitely rejecting this patch or should I fix indentation
> and send a v2?

I think I'll take it, I kinda hope nobody will really care much about it
but the behaviour looks better and the code is simpler, so ... :)

johannes

