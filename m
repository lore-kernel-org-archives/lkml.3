Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaEVKwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:52:01 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57531 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaEVKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:52:00 -0400
Date: Thu, 22 May 2014 11:51:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jay Aurabind <jay.aurabind@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: abx500-core: Remove unused function
 abx500_dump_all_banks()
Message-ID: <20140522105155.GR6679@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
 <537DD33B.6070401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537DD33B.6070401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > abx500_dump_all_banks() has no callers in the kernel, so it's probably
> > safe to remove it.
> > 
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/abx500-core.c | 20 --------------------
> >  1 file changed, 20 deletions(-)
> > 
> > diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
> > index d6d0ec4..fe41899 100644
> > --- a/drivers/mfd/abx500-core.c
> > +++ b/drivers/mfd/abx500-core.c
> > @@ -151,26 +151,6 @@ int abx500_startup_irq_enabled(struct device *dev, unsigned int irq)
> >  }
> >  EXPORT_SYMBOL(abx500_startup_irq_enabled);
> >  
> > -int abx500_dump_all_banks(void)
> > -{
> > -	struct abx500_ops *ops;
> > -	struct device *dummy_child;
> > -	struct abx500_device_entry *dev_entry;
> > -
> > -	dummy_child = kzalloc(sizeof(struct device), GFP_KERNEL);
> > -	if (!dummy_child)
> > -		return -ENOMEM;
> > -	list_for_each_entry(dev_entry, &abx500_list, list) {
> > -		dummy_child->parent = dev_entry->dev;
> > -		ops = &dev_entry->ops;
> > -
> > -		if ((ops != NULL) && (ops->dump_all_banks != NULL))
> > -			ops->dump_all_banks(dummy_child);
> > -	}
> > -	kfree(dummy_child);
> > -}
> > -EXPORT_SYMBOL(abx500_dump_all_banks);
> > -
> >  MODULE_AUTHOR("Mattias Wallin <mattias.wallin@stericsson.com>");
> >  MODULE_DESCRIPTION("ABX500 core driver");
> >  MODULE_LICENSE("GPL");
> > 
> Sorry for top posting previously, I was using gmail web interface. Looks
> like you forgot to remove this function's declaration from
> include/linux/mfd/abx500.h

You're right, good spot.

Will fix.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
