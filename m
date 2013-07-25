Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3GYNnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:43:15 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:40818 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab3GYNnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:43:13 -0400
Message-ID: <1374759740.1956.30.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 2/7] usb: phy: msm: Migrate to Managed Device
 Resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Thu, 25 Jul 2013 16:42:20 +0300
In-Reply-To: <20130724123822.GH17962@radagast>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
	 <1373384833-18077-3-git-send-email-iivanov@mm-sol.com>
	 <20130724123822.GH17962@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Wed, 2013-07-24 at 15:38 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jul 09, 2013 at 06:47:08PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Use managed device resources to clean up the probe/remove
> > and get DT support for free.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/phy/phy-msm-usb.c |   78 +++++++++++------------------------------
> >  1 file changed, 20 insertions(+), 58 deletions(-)
> > 
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > index ab1b880..cc37f5e 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> > @@ -1458,30 +1455,27 @@ static int __init msm_otg_probe(struct platform_device *pdev)
> >  	 * clock is introduced to remove the dependency on AXI
> >  	 * bus frequency.
> >  	 */
> > -	motg->core_clk = clk_get(&pdev->dev, "usb_hs_core_clk");
> > +	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");
> >  	if (IS_ERR(motg->core_clk))
> >  		motg->core_clk = NULL;
> >  
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (!res) {
> 
> no need to check for the resource when using devm_ioremap_resource()
> 
> >  		dev_err(&pdev->dev, "failed to get platform resource mem\n");
> > -		ret = -ENODEV;
> > -		goto put_core_clk;
> > +		return -ENODEV;
> >  	}
> >  
> > -	motg->regs = ioremap(res->start, resource_size(res));
> > +	motg->regs = devm_ioremap_resource(&pdev->dev, res);
> >  	if (!motg->regs) {
> >  		dev_err(&pdev->dev, "ioremap failed\n");
> 
> don't print error messages when using devm_ioremap_resource()

Will fix these places and re-send,

Thank you,
Ivan



