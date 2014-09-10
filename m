Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaIJNYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:24:23 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:34075 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaIJNYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:24:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Xiang Wang <wangx@marvell.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, Marcin Wojtas <mw@semihalf.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Xie <cxie4@marvell.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: fix error handling of sdhci_add_host
Date: Wed, 10 Sep 2014 16:24:22 +0300
Message-ID: <2073138.qpVRy5Xj3H@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <5513748.05vsM1lCJN@avalon>
References: <1405497009-20338-1-git-send-email-wangxfdu@gmail.com> <5513748.05vsM1lCJN@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 11:53:21 Laurent Pinchart wrote:
> On Wednesday 16 July 2014 15:50:09 Xiang Wang wrote:
> > From: Xiang Wang <wangx@marvell.com>
> > 
> > Commit 0dcaa2499b7d111bd70da5b0976c34210c850fb3 improved error
> > handling of sdhci_add_host. However, "err_of_parse" and "err_cd_req"
> > should be placed after "pm_runtime_disable(&pdev->dev)".
> > 
> > Signed-off-by: Xiang Wang <wangx@marvell.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I can't find the patch in mainline, has it been lost somewhere ?

> > ---
> > 
> >  drivers/mmc/host/sdhci-pxav3.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/sdhci-pxav3.c
> > b/drivers/mmc/host/sdhci-pxav3.c index 2fd73b3..0644655 100644
> > --- a/drivers/mmc/host/sdhci-pxav3.c
> > +++ b/drivers/mmc/host/sdhci-pxav3.c
> > @@ -380,11 +380,11 @@ static int sdhci_pxav3_probe(struct platform_device
> > *pdev)
> > 
> >  	return 0;
> > 
> > -err_of_parse:
> > 
> > -err_cd_req:
> >  err_add_host:
> >  	pm_runtime_put_sync(&pdev->dev);
> >  	pm_runtime_disable(&pdev->dev);
> > 
> > +err_of_parse:
> > 
> > +err_cd_req:
> >  	clk_disable_unprepare(clk);
> >  	clk_put(clk);
> >  
> >  err_clk_get:

-- 
Regards,

Laurent Pinchart

