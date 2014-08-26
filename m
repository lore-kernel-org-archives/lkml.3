Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaHZHmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:42:08 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53360 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbaHZHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:42:07 -0400
X-Auth-Info: FW0rXY74aU1OSThLxfGSBQ75yxtPMOB0zT8GS64gNh0=
From: Marek Vasut <marex@denx.de>
To: Robin Gong <b38343@freescale.com>
Subject: Re: [PATCH v4] spi: spi-imx: add DMA support
Date: Tue, 26 Aug 2014 09:26:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank.Li@freescale.com, shawn.guo@linaro.org
References: <1408752835-10995-1-git-send-email-b38343@freescale.com> <201408251007.22393.marex@denx.de> <20140826071757.GA32751@Robin-OptiPlex-780>
In-Reply-To: <20140826071757.GA32751@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201408260926.41038.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 26, 2014 at 09:17:59 AM, Robin Gong wrote:
> On Mon, Aug 25, 2014 at 10:07:22AM +0200, Marek Vasut wrote:
> > On Saturday, August 23, 2014 at 02:13:55 AM, Robin Gong wrote:
> > > After enable DMA
> > 
> > Please also add a commit message which describes the change, not only
> > some test results.
> > 
> > [...]
> 
>  Ok, I will enrich it in next version.
> 
> > > @@ -911,6 +1194,13 @@ static int spi_imx_probe(struct platform_device
> > > *pdev) goto out_put_per;
> > > 
> > >  	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
> > > 
> > > +	/*
> > > +	 * Only validated on i.mx6 now, can remove the constrain if validated
> > > on +	 * other chips.
> > > +	 */
> > 
> > Given that the check below tests for imx51_ecspi_devtype_data ... does
> > that mean, that this code was never tested on MX51 and MX53, yet will be
> > enabled for those chips and might possibly break them ?
> 
> Yes, because there is no available mx51 mx53 boards in my hands. But I
> think it won't bring too much trouble, since they share the same IP.
> No, the patch won't break current MX51 and MX53, because they didn't enable
> dma in dts setting,and they will keep use pio mode.

Thanks for clearing this up, this was the important piece of information for me. 
Please put it into the commit message.

Best regards,
Marek Vasut
