Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaGQKWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:22:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65512 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaGQKWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:22:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Chen <Peter.Chen@freescale.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Thu, 17 Jul 2014 12:21:56 +0200
Message-ID: <5456516.0fVZeXjF8k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <93903d5fdf85427bb8a418894540c122@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <22032517.gk8PRUMaIU@wuerfel> <93903d5fdf85427bb8a418894540c122@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bA+vbf8OkGgyB+A6fyWhMyKydYX9/bMpcCZ8WOaWjoo
 dbCc2dDTRPhdBqa3X/Ujbss/5C5xkHID+/0ixsiic7Ykg8Knnx
 RBYICciV5bUI90emg3731X2c5mHjr3DkestmBWVFBO1DuIunw5
 R+SL0WlXLEDJrSD3nwfWDxPJmGHVua5prqtZ4zaZlT6p+b9SH/
 9WB9RWHwlJp4DAb+TxAlzERNghkDhR2ZRNF94ye9/4J1sDGxMi
 z61uuGEAavpQTD9pDoMpBQxQEaQRH1mzKyPltCfiZZUFEulg4q
 eXb8EQkR55hfmB4pg6IQtALQutLt7kcPj9db8u43clcUp2WXzZ
 qZvPl/PPlgaNG2Qwb66E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 01:20:54 Peter Chen wrote:
> Thanks, arnd.
> 
> For chipidea generic glue layer case, if there are three devices who use this
> driver, and all devices have 32-bit bus, some devices have less 32 address lines.
> For example:
> 
> - the device_a doesn't need to use dma_mask
> - the device_b needs dma_mask as 0xfffffffff
> - the device_c needs dma_mask as 0xfffffff0, assume it has only 28 address lines

This makes no sense. You always need a dma mask, so the first case doesn't exist,
and the second one is the default.

In the third case, I assume you mean 0x0fffffff, which is a 28-bit mask.

> My questions are:
> - Can we not set dma_mask at driver, and only set dma-ranges at dts for device_b
> and device_c as a solution to cover this different dma mask use case?

try to understand my earlier reply. What is the problem with device_b?
Is that a limitation of the bus it is connected to, or the version of the
chipidea hardware?

> - If we can't use this solution, would you suggest one?

It depends on what the requirement of the hardware is, as I explained
now for three times.

> - If we can use this solution, for device_b and device_c, how can we write dma-ranges?
> I can't find any arm platforms use it, only some powerpc platform use it.
> According to the definition from Power_ePAPR_APPROVED_v1.1.pdf, it is
> dma-ranges = <child-bus-address, parent-bus-address, length>
> but I find the powerpc has different way for using dma-ranges. 

It's now handled by of_dma_configure() in drivers/of/platform.c for all
architectures.

	Arnd
