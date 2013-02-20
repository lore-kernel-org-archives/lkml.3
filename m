Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab3BTIgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:36:36 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47165 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3BTIgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:36:32 -0500
Date: Wed, 20 Feb 2013 00:36:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] mfd: menelaus: use devm_request_irq() and
 devm_kzalloc()
Message-ID: <20130220083629.GB4268@core.coreip.homeip.net>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002c01ce0f31$48d55e00$da801a00$%han@samsung.com>
 <20130220073044.GB2648@core.coreip.homeip.net>
 <000801ce0f41$00e79170$02b6b450$%han@samsung.com>
 <20130220081014.GA4268@core.coreip.homeip.net>
 <000d01ce0f42$ba3a1570$2eae4050$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01ce0f42$ba3a1570$2eae4050$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 05:17:30PM +0900, Jingoo Han wrote:
> On Wednesday, February 20, 2013 5:10 PM, Dmitry Torokhov wrote:
> > 
> > On Wed, Feb 20, 2013 at 05:05:10PM +0900, Jingoo Han wrote:
> > > On Wednesday, February 20, 2013 4:31 PM, Dmitry Torokhov wrote:
> > > >
> > > > Hi Jongoo,
> > > >
> > > > On Wed, Feb 20, 2013 at 03:12:38PM +0900, Jingoo Han wrote:
> > > > > Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> > > > > more simple.
> > > > >
> > > >
> > > > ...
> > > >
> > > > > @@ -1269,9 +1266,7 @@ static int __exit menelaus_remove(struct i2c_client *client)
> > > > >  {
> > > > >  	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
> > > > >
> > > > > -	free_irq(client->irq, menelaus);
> > > > >  	flush_work(&menelaus->work);
> > > > > -	kfree(menelaus);
> > > > >  	the_menelaus = NULL;
> > > > >  	return 0;
> > > >
> > > > This conversion is certainly wrong - you really want to disable IRQ and
> > > > then wait for the scheduled work to finish before freeing memory. Here
> > > > you flush work but nothing stops IRQ from firing and scheduling that
> > > > work again.
> > >
> > > Yes, you're right.
> > > I will use devm_free_irq() before flush_work().
> > 
> > Why change it at all if you have to call it manually in both error
> > unwinding and menelaus_remove() cases?
> > 
> > BTW, that __exit markup on menelaus_remove() is surprising... I am
> > pretty sure it can be unbound via sysfs and so there will be a nasty
> > oops.
> 
> I see, I will not modify this menelaus mfd driver.
> Thank you.

Same goes for the other drivers that can't safely use devm_request_irq()
please.

Thanks.

-- 
Dmitry
