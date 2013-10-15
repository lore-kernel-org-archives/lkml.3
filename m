Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3JOHNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:13:37 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:53840 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab3JOHNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:13:35 -0400
Message-ID: <1381821136.29983.15.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 12/13] usb: phy: msm: Properly check core interrupt
 number
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: mark.rutland@arm.com, linux-doc@vger.kernel.org, dwalker@fifo99.com,
        linux@arm.linux.org.uk, swarren@wwwdotorg.org, grant.likely@linaro.org,
        davidb@codeaurora.org, devicetree@vger.kernel.org,
        jackp@codeaurora.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-arm-msm@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        dsegal@codeaurora.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgautam@codeaurora.org, bryanh@codeaurora.org, rob@landley.net
Date: Tue, 15 Oct 2013 10:12:16 +0300
In-Reply-To: <20131014225933.GF7446@radagast>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
	 <1381764280-28420-13-git-send-email-iivanov@mm-sol.com>
	 <20131014225933.GF7446@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 17:59 -0500, Felipe Balbi wrote: 
> On Mon, Oct 14, 2013 at 06:24:39PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > IRQ with number 0 is valid case, so check for negative
> 
> not entirelly correct... IRQ 0 isn't supposed to be used as a linux IRQ
> number IIRC.

I am not really sure. NO_IRQ is -1 at least on ARM. Also when
taking into account irqdomain's zero as interrupt number is valid??

> 
> > numbers instead.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/phy/phy-msm-usb.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > index ca2abe6..f34c8a9 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> > @@ -1415,7 +1415,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
> >  	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);
> >  
> >  	motg->irq = platform_get_irq(pdev, 0);
> > -	if (!motg->irq) {
> > +	if (motg->irq < 0) {
> 
> this check is correct though, since platform_get_irq() will return
> -ENXIO if it doesn't find IRQ resource.
> 

Thanks,
Ivan

