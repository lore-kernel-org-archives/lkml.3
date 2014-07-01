Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaGAHYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:24:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60806 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757446AbaGAHYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:24:30 -0400
Date: Tue, 1 Jul 2014 09:24:24 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140701072424.GA8958@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
 <20140701002112.GA26146@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140701002112.GA26146@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Tue, Jul 01, 2014 at 08:21:14AM +0800, Peter Chen wrote:
> On Mon, Jun 30, 2014 at 03:33:13PM +0200, Antoine Ténart wrote:
> > On Fri, Jun 27, 2014 at 11:25:07AM +0800, Peter Chen wrote:
> > > On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
> > > >  
> > > >  ifneq ($(CONFIG_OF),)
> > > >  	obj-$(CONFIG_USB_CHIPIDEA)	+= usbmisc_imx.o ci_hdrc_imx.o
> > > > +	obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_generic.o
> > > >  endif
> > > 
> > > As a generic driver, you may need to support both dt and non-dt
> > > solution.
> > 
> > Since the dt is now the best practice and since there is no need (yet)
> > for a non-dt usage of this driver shouldn't we let anyone needing it
> > implement it when the time comes?
> > 
> 
> No, at least your code structure should support both dt and non-dt,
> and let the compile pass for non-dt platform if you don't have one.
> Then, someone with non-dt platform can change few to support it. 
> A good example is: drivers/usb/host/ehci-platform.c

Ok. I'll isolate dt-specific code in the probe, and remove the CONFIG_OF
dependency.

> 
> > > > +static int ci_hdrc_generic_probe(struct platform_device *pdev)
> > > > +{
> > > > +	struct device *dev = &pdev->dev;
> > > > +	struct ci_hdrc_generic_priv *priv;
> > > > +	struct ci_hdrc_platform_data ci_pdata = {
> > > > +		.name		= "ci_hdrc",
> > > 
> > > How about this using dev_name(&pdev->dev) for name?
> > 
> > Yes, why not. I don't have a strong preference.
> > 
> > > > +
> > > > +clk_err:
> > > > +	clk_disable_unprepare(priv->clk);
> > > 
> > > You may need to add "if (!IS_ERR(priv->clk))"
> > 
> > Right! I'll update this.
> > 
> > > > +
> > > > +static const struct of_device_id ci_hdrc_generic_of_match[] = {
> > > > +	{ .compatible = "chipidea-usb" },
> > > > +	{ }
> > > > +};
> > > 
> > > Even as a generic driver, you can also use your own compatible string.
> > 
> > Well, there is nothing specific about the Berlin CI. Some subsystems
> > use the 'generic' keyword in these cases. Do you see a particular reason
> > I should use some Berlin related compatible here?
> > 
> 
> Not must, one suggestion is: can you change the compatible string
> to "chipidea-usb-generic"?

Sounds good, I'll update.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
