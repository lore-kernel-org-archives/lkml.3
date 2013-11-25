Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3KYH3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 02:29:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53525 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3KYH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 02:29:30 -0500
Date: Mon, 25 Nov 2013 08:29:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
Message-ID: <20131125072923.GB28642@pengutronix.de>
References: <1382136588-15320-1-git-send-email-treding@nvidia.com>
 <20131122161607.GA5088@ulmo.nvidia.com>
 <528F86F2.40706@linaro.org>
 <20131122192257.GX28642@pengutronix.de>
 <52926F6F.3050104@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52926F6F.3050104@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Sun, Nov 24, 2013 at 10:28:15PM +0100, Daniel Lezcano wrote:
> On 11/22/2013 08:22 PM, Uwe Kleine-König wrote:
> >On Fri, Nov 22, 2013 at 05:31:46PM +0100, Daniel Lezcano wrote:
> >>On 11/22/2013 05:16 PM, Thierry Reding wrote:
> >>>On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
> >>Yes. Sounds like I missed it.
> >>
> >>This regression has been introduced by:
> >>
> >>commit 326e31eebe61dc838e031ea16968b2cfb43443e3
> >>Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >>Date:   Tue Oct 1 11:00:53 2013 +0200
> >>
> >>     clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE
> >>callbacks centrally
> >>
> >>     Instead of letting each driver call of_node_put do it centrally in the
> >>     loop that also calls the CLOCKSOURCE_OF_DECLARE callbacks. This is less
> >>     prone to error and also moves getting and putting the references
> >>into the
> >>     same function.
> >>
> >>     Consequently all respective of_node_put calls in drivers are removed.
> >>
> >>     Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>     Acked-by: David Brown <davidb@codeaurora.org>
> >Still all but the hook in clocksource_of_init of this commit was
> >correct, right? (Well, but this buggy hunk makes the commit log wrong.)
> 
> I don't understand your comment, can you elaborate ?
My patch added an of_node_put in clocksource_of_init and dropped several
of_node_puts in drivers. This thread is about the first being wrong. My
question was if dropping the others was correct.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
