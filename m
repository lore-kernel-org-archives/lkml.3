Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3I2SJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:09:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38461 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab3I2SJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:09:09 -0400
Date: Sun, 29 Sep 2013 19:09:06 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: devicetree@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
Message-ID: <20130929180906.GX3635@opensource.wolfsonmicro.com>
References: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20130925183201.GT3226@sirena.org.uk> <20130926152941.GQ3635@opensource.wolfsonmicro.com> <20130926175843.GS19304@sirena.org.uk> <20130928155308.GV3635@opensource.wolfsonmicro.com> <20130928225535.GQ19304@sirena.org.uk> <20130929141137.GW3635@opensource.wolfsonmicro.com> <20130929175236.GV19304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929175236.GV19304@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 06:52:36PM +0100, Mark Brown wrote:
> On Sun, Sep 29, 2013 at 03:11:37PM +0100, Charles Keepax wrote:
> 
> > There is currently only one other MFD driver (tps65910) which defines
> > the GPIOs on the main MFD node as we do in the Arizona driver and it
> > uses the 'hack' that I suggested in my first email of copying the
> > of_node.
> 
> > tps65910_gpio->gpio_chip.of_node = tps65910->dev->of_node;
> 
> Look where it's copying it to - this isn't the hack you were suggesting
> before.  What you were suggesting before was setting the of_node of the
> child struct device which is a managed thing that the driver core knows
> about, the device is the owner of the of_node hanging off it.  You would
> end up with the same of_node referenced from two struct devices which
> isn't clever.  The above is putting a pointer into the gpio_chip which
> is just telling gpiolib that it should use this of_node when it needs
> one, gpiolib won't try and lifecycle manage the of_node.

Ah, of course, I see now.


Thanks,
Charles

