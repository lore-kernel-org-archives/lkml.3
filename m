Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaIBBrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 21:47:39 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:37760 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaIBBri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 21:47:38 -0400
MIME-Version: 1.0
X-Originating-IP: [220.129.154.48]
In-Reply-To: <1407033419.17812.2.camel@phoenix>
References: <1407033419.17812.2.camel@phoenix>
Date: Tue, 2 Sep 2014 09:47:37 +0800
Message-ID: <CAFRkauB=2f5-zN5OAwx0LSYSnwuub_ONL+LuYYdy6-MxWQNzLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-03 10:36 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
> This driver uses GENERIC_IRQ_CHIP, so it needs to select GENERIC_IRQ_CHIP to
> avoid build error.
>
> Fixes below build errors:
> ERROR: "irq_alloc_domain_generic_chips" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> ERROR: "irq_gc_mask_clr_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> ERROR: "irq_gc_mask_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> ERROR: "irq_generic_chip_ops" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> ERROR: "irq_gc_ack_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> ERROR: "irq_get_domain_generic_chip" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Hi Greg,

I still hit this build error in today's linuex-next tree with below config:
ARCH_MULTIPLATFORM && !SOC_IMX5 && !SOC_IMX6Q && !SOC_IMX6SL

This driver just moved from staging to gpu.
So it's not clear to me who will pick up this patch.
Can you pick up this patch?

Thanks,
Axel
