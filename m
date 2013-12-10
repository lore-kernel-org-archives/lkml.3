Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3LJScY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:32:24 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:50480 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LJScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:32:22 -0500
Date: Tue, 10 Dec 2013 18:32:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 15/15] mfd: menelaus: Use devm_request_threaded_irq()
Message-ID: <20131210183214.GB2390@lee--X1>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-15-git-send-email-balbi@ti.com>
 <20131210093042.GU12675@lee--X1>
 <20131210163446.GH22750@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210163446.GH22750@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Felipe Balbi wrote:

> On Tue, Dec 10, 2013 at 09:30:42AM +0000, Lee Jones wrote:
> > On Mon, 09 Dec 2013, Felipe Balbi wrote:
> > 
> > > By using devm_request_threaded_irq() we can drop a few extra lines of
> > > code and rely on device managed resources layer to free our IRQ for us.
> > > 
> > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >  drivers/mfd/menelaus.c | 11 ++++-------
> > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> > > index bffe978..b87c2bd 100644
> > > --- a/drivers/mfd/menelaus.c
> > > +++ b/drivers/mfd/menelaus.c
> > > @@ -1271,8 +1271,8 @@ static int menelaus_probe(struct i2c_client *client,
> > >  	/* Set output buffer strengths */
> > >  	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
> > >  
> > > -	err = request_threaded_irq(client->irq, NULL, menelaus_irq,
> > > -			IRQF_ONESHOT, DRIVER_NAME, m);
> > > +	err = devm_request_threaded_irq(&client->dev, client->irq,
> > > +			NULL, menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
> > 
> > No need for a separate patch here. Convert straight from request_irq()
> > to devm_request_threaded_irq() in patch 3.
> 
> that would be 2 changes in a single patch.

I think it's the right thing to do.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
