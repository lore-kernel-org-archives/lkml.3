Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHRLDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:03:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30438 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHRLC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:02:58 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6a-53f1dd60b2c6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver
Date: Mon, 18 Aug 2014 13:02:49 +0200
Message-id: <3463371.y41zGdSnsX@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <34FCC3B2EE8F481198CEF3037F168FB3@sisodomain.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
 <1408026327-31437-4-git-send-email-b.zolnierkie@samsung.com>
 <34FCC3B2EE8F481198CEF3037F168FB3@sisodomain.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd2Eux+DDSa1K1kcvF9vsen6dVaL
	tisH2S1+vL7AZtG74CqbxYWnPWwWZ5vesFtc3jWHzWLG+X1MFouWtTI7cHncubaHzaNvyypG
	j+M3tjN5fN4kF8ASxWWTkpqTWZZapG+XwJVxqvk2a0EHf8WCH0fZGhiX8nQxcnJICJhIXLw6
	gxXCFpO4cG89G4gtJDCdUWL62mIIu4VJ4uAEPRCbTcBKYmL7KkYQW0RAW2L73ElAvVwczAIH
	mCS6pi5iAkkIC3hKbF90F8xmEVCVmLzqItgCXgFNiYbmd2DNokA1O7avBFvGKWAn8XXDWkaQ
	QUICuxkljnStZIZoEJT4MfkeC4jNLCAvsW//VFYIW0ei9/s35gmMArOQlM1CUjYLSdkCRuZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGB/0xqB+PKBotDjAIcjEo8vB6vPwQLsSaWFVfm
	HmKU4GBWEuHNPv8xWIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgs
	EwenVANjy1LLW9O4iprnOOs7eIVMtAs5GCf/UDDj45xH8oI3V937HlCk+H4ZwxPJ9a8cX3zR
	ne5y4sX3hzcbPnDfPqLn6q2p+2SFgtzUr9XX1zpHPPy7ki/Gl+GlYuk7D9cbYg7/GiYvN+Be
	e6SMRfXhL/YLWuW3Hqvqy+SGGv2PnpiuVLPrSOSkLVlnlFiKMxINtZiLihMBckrkU3gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, August 14, 2014 08:07:40 PM Vivek Gautam wrote:
> Hi Bartlomiej Zolnierkiewicz,
> 
> 
> On Thursday, August 14, 2014 7:55 PM, Bartlomiej Zolnierkiewicz 
> <b.zolnierkie@samsung.com> wrote
> 
> Subject: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver
> 
> I would say it co-incidence that both of us sent the patch-series for 
> similar cleanup at the same time. ;)

:)

> There's one thing that I would want to comment here, since we don't have any 
> new usb-phy driver for S3C64XX,
> so we can't simply remove this entire driver.
> I have posted my patch-series [1], which does cleanup while keeping the 
> support for S3C64XX.

AFAIK S3C64XX code from drivers/usb/phy/phy-samsung-usb2.c has
never been used as this platform still uses its own code from
arch/arm/mach-s3c64xx/setup-usb-phy.c (there are no users in
the kernel tree of either s3c64xx-usb2phy platform device or
"samsung,s3c64xx-usb2phy" DT compatible) .  Therefore I think
that the entire drivers/usb/phy/phy-samsung-usb2.c driver
should be removed (somebody with the hardware can as well add
S3C64XX support to the new drivers/phy/phy-samsung-usb2.c
driver and port the platform to use it).

> Please let me know what you think of that series.
> 
> [1] [PATCH 0/7] usb-phy: samsung: Cleanup the unused drivers
>       https://lkml.org/lkml/2014/8/14/235

Looks fine to me except the above mentioned issue with S3C64XX
platform support.

> > drivers/usb/phy/phy-samsung-usb2 driver got replaced by
> > drivers/phy/phy-samsung-usb2 one and is no longer used.
> >
> > Cc: Kamil Debski <k.debski@samsung.com>
> > Cc: Vivek Gautam <gautam.vivek@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

