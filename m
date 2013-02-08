Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946554Ab3BHMrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:47:41 -0500
Received: from etezian.org ([198.101.225.253]:38430 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946353Ab3BHMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:47:39 -0500
Date: Fri, 8 Feb 2013 13:48:30 +0100
From: Andi Shyti <andi@etezian.org>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: Andi Shyti <andi@etezian.org>, tomi.valkeinen@ti.com,
        FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Message-ID: <20130208124829.GB10564@jack.whiskey>
References: <1360248051-16541-1-git-send-email-ruslan.bilovol@ti.com>
 <1360248051-16541-2-git-send-email-ruslan.bilovol@ti.com>
 <20130207145952.GA7860@jack.whiskey>
 <CAB=otbTH8bQp5X4Y2cvMYKwYqMbT0HQxmuRD9gRtna=-vy2ptA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=otbTH8bQp5X4Y2cvMYKwYqMbT0HQxmuRD9gRtna=-vy2ptA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Thanks for looking into

if you want you can put me in CC and I can review the next
patches (perhaps V2 of the patches)

> >> +     mutex_lock(&tc358765_i2c->xfer_lock);
> >> +     ret = i2c_transfer(tc358765_i2c->client->adapter, &msg, 1);
> >> +     mutex_unlock(&tc358765_i2c->xfer_lock);
> >
> > What about using smbus?
> 
> OMAP2+ SoCs have full I2C controller so panel drivers traditionally use I2C.
> Since implementation is OMAP-specific, I don't think we need to use smbus here.
> 
> Also please look at other panels implementation:
> drivers/video/omap2/displays/panel-tfp410.c
> drivers/video/omap2/displays/panel-picodlp.c

Yeah, it's the same problem with other i2c drivers, they should
be written to be working as much as possible with the emulated
smbus.

I don't actually know the internals of the omap2 driver
controller, but not being able to use smbus, definitely sucks!

> Will be fixed in next patchset

What about sending a patch V2? :)

Andi
