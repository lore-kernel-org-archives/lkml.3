Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaKJNxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:53:49 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:43796 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaKJNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:53:48 -0500
Date: Mon, 10 Nov 2014 13:53:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tc6393xb: prepare/unprepare clocks
Message-ID: <20141110135328.GB24004@x1>
References: <1415263958-16644-1-git-send-email-dbaryshkov@gmail.com>
 <20141106090424.GB26543@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141106090424.GB26543@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2014, Lee Jones wrote:

> On Thu, 06 Nov 2014, Dmitry Eremin-Solenikov wrote:
> 
> > Change clk_enable/disable() calls to clk_prepare_enable() and
> > clk_disable_unrepapre().
> > 
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > ---
> >  drivers/mfd/tc6393xb.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Applied, thanks.

OOI, what kernel version was this patch based on?

> > diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> > index 48579e5..abcb4eb 100644
> > --- a/drivers/mfd/tc6393xb.c
> > +++ b/drivers/mfd/tc6393xb.c
> > @@ -665,7 +665,7 @@ static int tc6393xb_probe(struct platform_device *dev)
> >  		goto err_ioremap;
> >  	}
> >  
> > -	ret = clk_enable(tc6393xb->clk);
> > +	ret = clk_prepare_enable(tc6393xb->clk);
> >  	if (ret)
> >  		goto err_clk_enable;
> >  
> > @@ -728,7 +728,7 @@ err_gpio_add:
> >  		temp = gpiochip_remove(&tc6393xb->gpio);
> >  	tcpd->disable(dev);
> >  err_enable:
> > -	clk_disable(tc6393xb->clk);
> > +	clk_disable_unprepare(tc6393xb->clk);
> >  err_clk_enable:
> >  	iounmap(tc6393xb->scr);
> >  err_ioremap:
> > @@ -764,7 +764,7 @@ static int tc6393xb_remove(struct platform_device *dev)
> >  	}
> >  
> >  	ret = tcpd->disable(dev);
> > -	clk_disable(tc6393xb->clk);
> > +	clk_disable_unprepare(tc6393xb->clk);
> >  	iounmap(tc6393xb->scr);
> >  	release_resource(&tc6393xb->rscr);
> >  	clk_put(tc6393xb->clk);
> > @@ -792,7 +792,7 @@ static int tc6393xb_suspend(struct platform_device *dev, pm_message_t state)
> >  			ioread8(tc6393xb->scr + SCR_GPI_BCR(i));
> >  	}
> >  	ret = tcpd->suspend(dev);
> > -	clk_disable(tc6393xb->clk);
> > +	clk_disable_unprepare(tc6393xb->clk);
> >  
> >  	return ret;
> >  }
> > @@ -804,7 +804,7 @@ static int tc6393xb_resume(struct platform_device *dev)
> >  	int ret;
> >  	int i;
> >  
> > -	clk_enable(tc6393xb->clk);
> > +	clk_prepare_enable(tc6393xb->clk);
> >  
> >  	ret = tcpd->resume(dev);
> >  	if (ret)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
