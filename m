Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaIBCLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 22:11:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIBCLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 22:11:20 -0400
Date: Mon, 1 Sep 2014 19:11:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build
 error
Message-ID: <20140902021119.GA2525@kroah.com>
References: <1407033419.17812.2.camel@phoenix>
 <CAFRkauB=2f5-zN5OAwx0LSYSnwuub_ONL+LuYYdy6-MxWQNzLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRkauB=2f5-zN5OAwx0LSYSnwuub_ONL+LuYYdy6-MxWQNzLw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 09:47:37AM +0800, Axel Lin wrote:
> 2014-08-03 10:36 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
> > This driver uses GENERIC_IRQ_CHIP, so it needs to select GENERIC_IRQ_CHIP to
> > avoid build error.
> >
> > Fixes below build errors:
> > ERROR: "irq_alloc_domain_generic_chips" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > ERROR: "irq_gc_mask_clr_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > ERROR: "irq_gc_mask_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > ERROR: "irq_generic_chip_ops" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > ERROR: "irq_gc_ack_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > ERROR: "irq_get_domain_generic_chip" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> Hi Greg,
> 
> I still hit this build error in today's linuex-next tree with below config:
> ARCH_MULTIPLATFORM && !SOC_IMX5 && !SOC_IMX6Q && !SOC_IMX6SL
> 
> This driver just moved from staging to gpu.
> So it's not clear to me who will pick up this patch.
> Can you pick up this patch?

As the code isn't in the staging tree, why shouldn't it go through the
drivers/gpu/* maintainer?

thanks,

greg k-h
