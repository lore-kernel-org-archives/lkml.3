Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967027Ab3DRJYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:24:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32868 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966307Ab3DRJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:24:42 -0400
Date: Thu, 18 Apr 2013 11:24:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130418092436.GB21099@pengutronix.de>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <201304172223.43707.arnd@arndb.de>
 <20130418081555.GV30416@pengutronix.de>
 <201304181101.13644.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181101.13644.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:01:13AM +0200, Arnd Bergmann wrote:
> On Thursday 18 April 2013, Uwe Kleine-König wrote:
> > > > + * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
> > > > + * 16 irqs.
> > > > + */
> > > > +#define NVIC_MAX_IRQ               ((NVIC_MAX_BANKS - 1) * 32 + 16)
> > > 
> > > Is this actually inherent to the hardware design, or is the number of irqs
> > > actually customizable? Also, why do you care about the maximum? You only
> > > use it to check against the device tree provided value, but I suppose
> > > you could just as well trust that property to be correct.
> > I don't provide a value for the number of irqs in the device tree. There
> > is only the value INTLINESNUM in the V7M_SCS_ICTR register that is used
> > to determine the number of interrupt banks.
> 
> Ah, right. But do you have any reason to believe it could be wrong?
No it's just that the mapping isn't linear in the end.

	INTLINESNUM | number of irqs
	      0     |     32
	      1     |     64
	      2     |     96
	      3     |    128
	      4     |    160
	      5     |    192
	      6     |    224
	      7     |    256
	      8     |    288
	      9     |    320
	     10     |    352
	     11     |    384
	     12     |    416
	     13     |    448
	     14     |    480
	     15     |    496

That is, there are (INTLINESNUM + 1) * 32 irqs for INTLINESNUM < 15. For
INTLINESNUM == 15 there are only 496 and not 16 * 32 == 512. That's the
same on the gic (just with bigger numbers).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
