Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030442Ab3DSNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:51:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968179Ab3DSNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:51:14 -0400
Date: Fri, 19 Apr 2013 15:51:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130419135107.GD15233@pengutronix.de>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <201304181101.13644.arnd@arndb.de>
 <20130418092436.GB21099@pengutronix.de>
 <201304181138.13599.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181138.13599.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:38:13AM +0200, Arnd Bergmann wrote:
> On Thursday 18 April 2013, Uwe Kleine-König wrote:
> > That is, there are (INTLINESNUM + 1) * 32 irqs for INTLINESNUM < 15. For
> > INTLINESNUM == 15 there are only 496 and not 16 * 32 == 512. That's the
> > same on the gic (just with bigger numbers).
> 
> Ok, but since you are now using a linear domain, it doesn't actually hurt
> to register 512 in that special case, right?
Well, it depends if allocating space for 16 unused unsigned ints hurts
(maybe not). And it makes mapping some irqs successfull while the irq
doesn't really exist. But probably this doesn't hurt either because the
problem already exists.

I don't care much. Is there another advantage beside saving a few source
lines/instructions?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
