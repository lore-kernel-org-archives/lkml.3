Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaGABxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:53:16 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:58986
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757227AbaGABxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:53:11 -0400
Date: Tue, 1 Jul 2014 08:21:14 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140701002112.GA26146@shlinux1.ap.freescale.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140630133313.GA11880@kwain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(80022001)(85306003)(95666004)(104016002)(77982001)(76482001)(79102001)(46102001)(68736004)(4396001)(31966008)(6806004)(74502001)(92726001)(54356999)(97736001)(44976005)(83322001)(69596002)(64706001)(93886003)(105606002)(107046002)(33656002)(99396002)(50986999)(20776003)(47776003)(106466001)(81156004)(102836001)(26826002)(83072002)(74662001)(23756003)(86362001)(92566001)(81342001)(76176999)(81542001)(87936001)(50466002)(85852003)(21056001)(83506001)(84676001)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB081;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02596AB7DA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:33:13PM +0200, Antoine Ténart wrote:
> Peter,
> 
> On Fri, Jun 27, 2014 at 11:25:07AM +0800, Peter Chen wrote:
> > On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
> > >  
> > >  ifneq ($(CONFIG_OF),)
> > >  	obj-$(CONFIG_USB_CHIPIDEA)	+= usbmisc_imx.o ci_hdrc_imx.o
> > > +	obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_generic.o
> > >  endif
> > 
> > As a generic driver, you may need to support both dt and non-dt
> > solution.
> 
> Since the dt is now the best practice and since there is no need (yet)
> for a non-dt usage of this driver shouldn't we let anyone needing it
> implement it when the time comes?
> 

No, at least your code structure should support both dt and non-dt,
and let the compile pass for non-dt platform if you don't have one.
Then, someone with non-dt platform can change few to support it. 
A good example is: drivers/usb/host/ehci-platform.c

> > > +static int ci_hdrc_generic_probe(struct platform_device *pdev)
> > > +{
> > > +	struct device *dev = &pdev->dev;
> > > +	struct ci_hdrc_generic_priv *priv;
> > > +	struct ci_hdrc_platform_data ci_pdata = {
> > > +		.name		= "ci_hdrc",
> > 
> > How about this using dev_name(&pdev->dev) for name?
> 
> Yes, why not. I don't have a strong preference.
> 
> > > +
> > > +clk_err:
> > > +	clk_disable_unprepare(priv->clk);
> > 
> > You may need to add "if (!IS_ERR(priv->clk))"
> 
> Right! I'll update this.
> 
> > > +
> > > +static const struct of_device_id ci_hdrc_generic_of_match[] = {
> > > +	{ .compatible = "chipidea-usb" },
> > > +	{ }
> > > +};
> > 
> > Even as a generic driver, you can also use your own compatible string.
> 
> Well, there is nothing specific about the Berlin CI. Some subsystems
> use the 'generic' keyword in these cases. Do you see a particular reason
> I should use some Berlin related compatible here?
> 

Not must, one suggestion is: can you change the compatible string
to "chipidea-usb-generic"?

-- 

Best Regards,
Peter Chen
