Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3JAIIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:08:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59671 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3JAIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:08:33 -0400
Date: Tue, 1 Oct 2013 10:08:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
Message-ID: <20131001080829.GJ2548@pengutronix.de>
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <5242F434.7060702@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5242F434.7060702@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > I'm not sure that the way I implemented if a given timer is used as
> > clock_source or clock_event_device is robust. Does it need locking?
> > The reason to create a timer device for each timer instead of a single
> > device of all of them is that it makes it cleaner to specify irqs and
> > clks which each timer has one of each respectively. I didn't find an
> > example, but while looking I wondered if in zevio-timer.c a single timer
> > can really support both clock_event and clocksource.
> > 
> > I guess for inclusion I need to write a document describing the
> > of-binding. I will include that in the next iteration.
> 
> Right and a nice description of the timer would be valuable.
Where is the location to put a device tree binding document for a
clocksource/clock event device? I found

	arm,armv7-timer-mem	| arm/arch_timer.txt
	fsl,timrot		| N/A
	nvidia,tegra20-rtc	| rtc/nvidia,tegra20-rtc.txt

Should I introduce a "clocksource" directory below
Documentation/devicetree/bindings?

Other than that if there are no further comments I'll sent a v2 soon.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
