Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaERPin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:38:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55560 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaERPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:38:41 -0400
Date: Sun, 18 May 2014 17:38:51 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: walter harms <wharms@bfs.de>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: fix error handling
Message-ID: <20140518153851.GB4310@lianli>
References: <1400234045-6022-1-git-send-email-emilgoode@gmail.com>
 <5375EB13.8000200@bfs.de>
 <20140516111646.GC4366@lianli>
 <5375FB36.8020004@bfs.de>
 <20140516193139.GQ16662@pengutronix.de>
 <20140517153540.GA4309@lianli>
 <20140517190546.GC16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517190546.GC16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I appologise for providing incomplete information in my previous message.

The involved call sites are the following:

arch/arm/mach-imx/mach-mx35_3ds.c +265

imx35_3ds_init_camera()
	imx35_alloc_mx3_camera()
		imx_alloc_mx3_camera()
	dma_declare_coherent_memory()
	platform_device_add()

arch/arm/mach-imx/mach-mx31moboard.c +477

mx31moboard_init_cam()
	imx31_alloc_mx3_camera()
		imx_alloc_mx3_camera()
	dma_declare_coherent_memory()
	platform_device_add()

arch/arm/mach-imx/mach-mx31_3ds.c +182

mx31_3ds_init_camera()
	imx31_alloc_mx3_camera()
		imx_alloc_mx3_camera()
	dma_declare_coherent_memory()
	platform_device_add()

arch/arm/mach-imx/mach-pcm037.c +413

pcm037_init_camera()
	imx31_alloc_mx3_camera()
		imx_alloc_mx3_camera()
	dma_declare_coherent_memory()
	platform_device_add()

Sorry about the mistake!

Best regards,

Emil Goode
