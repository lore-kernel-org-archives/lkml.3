Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaCGRiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:38:46 -0500
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:43213
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbaCGRin convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:38:43 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH v2 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOeCV9DNjRc3B2UCeO8iaoS1qYZrV4oiw
Date: Fri, 7 Mar 2014 17:38:41 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA712C@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394181476-17153-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394181476-17153-1-git-send-email-chase.southwood@yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 07, 2014 1:38 AM, Chase Southwood wrote:
> This patch fixes the register map defines for the counter registers such
> that they are all the real offsets to each register, rather than a mix of
> real offsets and adders to those offsets.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>
> 2: Simplified commit message, fixed indentation and whitespace damage.
> I have test applied this patch, it should work now.
> v2 also fixes several build breakages, and I have compile tested as well.
> Everything should be fixed.

Chase,

Looks better, the patches apply now.

The register map whitespace is still a bit of a mess. This is what it looks like
after applying all 5 patches:

/*
 * devpriv->i_IobaseAmcc Register Map
 */
#define APCI1564_DI_REG						0x04
#define APCI1564_DI_INT_MODE1_REG				0x08
#define APCI1564_DI_INT_MODE2_REG				0x0c
#define APCI1564_DI_INT_STATUS_REG				0x10
#define APCI1564_DI_IRQ_REG					0x14
#define APCI1564_DO_REG						0x18
#define APCI1564_DO_INT_CTRL_REG				0x1c
#define APCI1564_DO_INT_STATUS_REG				0x20
#define APCI1564_DO_IRQ_REG					0x24
#define APCI1564_WDOG_REG						0x28
#define APCI1564_WDOG_RELOAD_REG				0x2c
#define APCI1564_WDOG_TIMEBASE_REG				0x30
#define APCI1564_WDOG_CTRL_REG					0x34
#define APCI1564_WDOG_STATUS_REG				0x38
#define APCI1564_WDOG_IRQ_REG					0x3c
#define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
#define APCI1564_WDOG_WARN_TIMEBASE_REG		0x44
#define APCI1564_TIMER_REG						0x48
#define APCI1564_TIMER_RELOAD_REG				0x4c
#define APCI1564_TIMER_TIMEBASE_REG			0x50
#define APCI1564_TIMER_CTRL_REG				0x54
#define APCI1564_TIMER_STATUS_REG				0x58
#define APCI1564_TIMER_IRQ_REG					0x5c
#define APCI1564_TIMER_WARN_TIMEVAL_REG		0x60
#define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64

/*
 * devpriv->iobase Register Map
 */
#define APCI1564_TCW_REG(x)					(0x00 + ((x) * 0x20))
#define APCI1564_TCW_RELOAD_REG(x)				(0x04 + ((x) * 0x20))
#define APCI1564_TCW_TIMEBASE_REG(x)			(0x08 + ((x) * 0x20))
#define APCI1564_TCW_CTRL_REG(x)				(0x0c + ((x) * 0x20))
#define APCI1564_TCW_STATUS_REG(x)				(0x10 + ((x) * 0x20))
#define APCI1564_TCW_IRQ_REG(x)				(0x14 + ((x) * 0x20))
#define APCI1564_TCW_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 0x20))
#define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))

Check your tab settings in your editor. Normal tab spacing is 8 characters.
It looks like all the defines align properly at column 49 which is one tab after
the define on this line:

#define APCI1564_TCW_WARN_TIMEBASE_REG(x)	(0x1c + ((x) * 0x20))

Other than that the patches look good.

Regards,
Hartley
