Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaKTOYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:24:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42041 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaKTOYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:24:41 -0500
From: "Griffis, Brad" <bgriffis@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
CC: "R, Vignesh" <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        "Pawel Moll" <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Benoit Cousson" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        "Hartmut Knaack" <knaack.h@gmx.de>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>
Subject: RE: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Topic: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Index: AQHP/814MDA7S36n+UqTsn1qrVW9DZxm3USAgAAtbQCAAu23AP//nLkQ
Date: Thu, 20 Nov 2014 14:23:30 +0000
Message-ID: <912A29987EAE174BA6CF187D7CDFA9CE26F69163@DLEE08.ent.ti.com>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-4-git-send-email-vigneshr@ti.com>
 <20141118143005.GF24004@x1> <20141118171240.GB3003@dtor-ws>
 <546DF2F0.9080405@ti.com>
In-Reply-To: <546DF2F0.9080405@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nori, Sekhar
> Sent: Thursday, November 20, 2014 7:56 AM
>
> I also tested this series on AM335x EVM using the v3.18-rc5 kernel.
> Again, no breakage but no improvement as well.

The primary goal was not necessarily to improve performance of the touchscreen itself.  It was to reduce unnecessary CPU overhead introduced by the 275us udelay in the ISR.  On a related note, that 275us udelay is not something that worked for all boards.  For example, see the following forum thread:

http://e2e.ti.com/support/arm/sitara_arm/f/791/p/217587/775152.aspx#775152

In that thread the user was registering multiple press events for a single press.  By increasing the udelay to 1.5ms they were able to solve the problem.  Of course, having a 1.5ms delay in your ISR is a really bad thing to do...

I have another customer that was experiencing the same issue of registering multiple press events, and sure enough the 1.5ms delay "fixed" their problem too.  The patches allowed them to remove that gigantic delay from the ISR because that software delay has now become a hardware delay via CHARGECONFIG.  That customer is the one that needed 0xB000 which is MUCH larger than the value of 0x400 that was working fine for me on the EVM.
