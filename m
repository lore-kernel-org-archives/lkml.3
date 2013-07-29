Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3G2S7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:59:51 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45028 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3G2S7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:59:50 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: balbi@ti.com
Cc: Illia Smyrnov <illia.smyrnov@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for keypad.
Date: Mon, 29 Jul 2013 11:59:45 -0700
Message-ID: <7605900.g1IUvSbegi@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.5 (Linux/3.9.9-201.fc18.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130729180441.GF4964@radagast>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com> <1375116311-13999-2-git-send-email-illia.smyrnov@ti.com> <20130729180441.GF4964@radagast>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 09:04:41 PM Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jul 29, 2013 at 07:45:09PM +0300, Illia Smyrnov wrote:
> > Enable/disable IRQ wake in suspend/resume handlers
> > to make the keypad wakeup capable.
> > 
> > Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> > ---
> > 
> >  drivers/input/keyboard/omap4-keypad.c |   43
> >  +++++++++++++++++++++++++++++++++ 1 file changed, 43 insertions(+)
> > 
> > diff --git a/drivers/input/keyboard/omap4-keypad.c
> > b/drivers/input/keyboard/omap4-keypad.c index 0244262..feab00f 100644
> > --- a/drivers/input/keyboard/omap4-keypad.c
> > +++ b/drivers/input/keyboard/omap4-keypad.c
> > @@ -74,6 +74,7 @@ struct omap4_keypad {
> > 
> >  	struct input_dev *input;
> >  	
> >  	void __iomem *base;
> > 
> > +	bool irq_wake_enabled;
> 
> this flag is a bit weird... but I can't find a better way to handle this
> situation. In one way, you shouldn't prevent system suspend, so you can
> error out in case enable_irq_wake() fails, otoh if enable_irq_wake()
> fails and you return 0, on resume disable_irq_wake() will throw
> unbalanced calls warning. Maybe someone else has a better idea.
> 
> > @@ -439,12 +444,50 @@ static const struct of_device_id
> > omap_keypad_dt_match[] = {> 
> >  MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> >  #endif
> > 
> > +#ifdef CONFIG_PM_SLEEP
> > +static int omap4_keypad_suspend(struct device *dev)
> > +{
> > +	struct platform_device *pdev = to_platform_device(dev);
> 
> you don't need to access the platform_device...
> 
> > +	struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
> 
> ... since this can become:
> 
> 	struct omap4_keypad *keypad_data = dev_get_drvdata(dev);

No, please use correct accessors for the objects. Platform drivers deal
with platform devices and I prefer using platform_get_drvdata() on them.

Thanks.

-- 
Dmitry
