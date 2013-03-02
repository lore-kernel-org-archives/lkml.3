Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3CCMIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:08:32 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45173 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3CCMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:07:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3] spi: tegra114: add spi driver
To: Manish Badarkhe <badarkhe.manish@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: rob.herring@calxeda.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-tegra@vger.kernel.org, swarren@nvidia.com
In-Reply-To: <CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com>
References: <1361536659-23225-1-git-send-email-ldewangan@nvidia.com> <CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com>
Date: Sat, 02 Mar 2013 23:09:06 +0000
Message-Id: <20130302230906.141BE3E336A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 19:59:11 +0530, Manish Badarkhe <badarkhe.manish@gmail.com> wrote:
> On Fri, Feb 22, 2013 at 6:07 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> > Add SPI driver for NVIDIA's Tegra114 SPI controller. This controller
> > is different than the older SoCs SPI controller in internal design as
> > well as register interface.
> >
> > This driver supports the:
> > - non DMA based transfer for smaller transfer i.e. less than FIFO depth.
> > - APB DMA based transfer for lager transfer i.e. more than FIFO depth.
> 
> s/lager/larger

Applied, thanks. And I fixed up the typo when I did.

> > +       spi_irq = platform_get_irq(pdev, 0);
> > +       tspi->irq = spi_irq;
> > +       ret = request_threaded_irq(tspi->irq, tegra_spi_isr,
> > +                       tegra_spi_isr_thread, IRQF_ONESHOT,
> > +                       dev_name(&pdev->dev), tspi);
> 
> Can we use devm_request_threaded_irq instead? to save some code.

I don't have any quams about applying it as-is. That can be done as a
follow on patch.

g.

