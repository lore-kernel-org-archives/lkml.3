Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967567Ab3DRJie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:38:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967323Ab3DRJic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:38:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Date: Thu, 18 Apr 2013 11:38:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de> <201304181101.13644.arnd@arndb.de> <20130418092436.GB21099@pengutronix.de>
In-Reply-To: <20130418092436.GB21099@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201304181138.13599.arnd@arndb.de>
X-Provags-ID: V02:K0:MuEZqtNqDsltqjqQM7SB0FSWeVeJlKdjUjzjtSGm3gG
 P4Adx5jQvkiPf++5Jeme2CyOhIyHNet1oXPl9Qb4M1H/vl4Ej0
 xw+m6hhGf0voPTzCGGwfps9aI2yhjrvOGTxZNCHOO1D8COxVmo
 R/AVqMu4JW3l705smi3K4HV+kYM1CezYenLKNElvZent4zSX6V
 l24kX76Y+/SK9/W226mzI0w9gLrO/TAhq6gP8oCmk6c6FisBb3
 0o5XGImgB9z2Xg3Bv+SYzlNHdvkZD1y4VHrfCTzOn/fEKU4P68
 W7vhQiQw56iBTycTJd+CoJYggTdyH/Pfe4EfWXd6u77EcEIXKG
 fYXfLXlfsBB8r6QHinwQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Uwe Kleine-König wrote:
> That is, there are (INTLINESNUM + 1) * 32 irqs for INTLINESNUM < 15. For
> INTLINESNUM == 15 there are only 496 and not 16 * 32 == 512. That's the
> same on the gic (just with bigger numbers).

Ok, but since you are now using a linear domain, it doesn't actually hurt
to register 512 in that special case, right?

	Arnd
