Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBMLQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:16:16 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:38012 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBMLQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:16:14 -0500
Date: Thu, 13 Feb 2014 11:16:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
Message-ID: <20140213111607.GK32508@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
 <20140213095817.GD32508@lee--X1>
 <20140213111530.2a2b4982@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140213111530.2a2b4982@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Jean Delvare wrote:

> On Thu, 13 Feb 2014 09:58:17 +0000, Lee Jones wrote:
> > > The MFD driver has now been added, so this driver is now being adopted to be a
> > > subdevice driver on top of it. This means, the i2c driver usage is being
> > > converted to platform driver usage all around.
> > > 
> > > Signed-off-by: Laszlo Papp <lpapp@kde.org>
> > > ---
> > > This patch has been compile tested only and will be tested with real hardware,
> > > but early reviews to catch any trivial issues would be welcome.
> > >  drivers/hwmon/Kconfig   |   2 +-
> > >  drivers/hwmon/max6650.c | 155 ++++++++++++++++++++++++------------------------
> > >  2 files changed, 79 insertions(+), 78 deletions(-)
> > 
> > <snip>
> > 
> > >  /*
> > >   * Insmod parameters
> > > @@ -105,24 +108,23 @@ module_param(clock, int, S_IRUGO);
> > >  
> > >  #define DIV_FROM_REG(reg) (1 << (reg & 7))
> > >  
> > > -static int max6650_probe(struct i2c_client *client,
> > > -			 const struct i2c_device_id *id);
> > > -static int max6650_init_client(struct i2c_client *client);
> > > -static int max6650_remove(struct i2c_client *client);
> > > +static int max6650_probe(struct platform_device *pdev);
> > > +static int max6650_init_client(struct platform_device *pdev);
> > > +static int max6650_remove(struct platform_device *pdev);
> > >  static struct max6650_data *max6650_update_device(struct device *dev);
> > 
> > It would be good to remove these forward declarations in the future.
> > 
> > If no one volunteers I'll happily do it.
> 
> Guenter just did:
> 
> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html

Nice, FWIW:
  Acked-by: Lee Jones <lee.jones@linaro.org>  

> Any change to the max6650 driver should go on top of his patch series
> to avoid conflicts:
> 
> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html

Do you have a tree Laszlo can rebase on top of?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
