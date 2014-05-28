Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaE1K7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:59:33 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.117]:13911 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbaE1K7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:59:31 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-15.tower-193.messagelabs.com!1401274767!16512042!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 28 May 2014 12:59:28 +0200
Date: Wed, 28 May 2014 13:51:59 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140528115159.GA2090@awelinux>
References: <cover.1401181010.git.andreas.werner@men.de>
 <a3cd43562effd2580d0174c56eff5584791217ac.1401181010.git.andreas.werner@men.de>
 <20140527150547.GA4227@lee--X1>
 <20140528070222.GA24101@jtlinux>
 <20140528082404.GA10803@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140528082404.GA10803@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aOn Wed, May 28, 2014 at 09:24:05AM +0100, Lee Jones wrote:
> > > > The MEN 14F021P00 Board Management Controller provides an
> > > > I2C interface to the host to access the feature implemented in the BMC.
> > > > The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> > > > and on a few Box/Display Computer.
> > > >
> > > > Added MFD Core driver, supporting the I2C communication to the device.
> > > >
> > > > The MFD driver currently supports the following features:
> > > > 	- Watchdog
> > > > 	- LEDs
> > > >
> > > > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > > > ---
> > > >  drivers/mfd/Kconfig           |  12 +++
> > > >  drivers/mfd/Makefile          |   1 +
> > > >  drivers/mfd/menf21bmc.c       | 220 ++++++++++++++++++++++++++++++++++++++++++
> > > >  include/linux/mfd/menf21bmc.h |  31 ++++++
> > > >  4 files changed, 264 insertions(+)
> > > >  create mode 100644 drivers/mfd/menf21bmc.c
> > > >  create mode 100644 include/linux/mfd/menf21bmc.h
> 
> [...]
> 
> > > > +static int menf21bmc_write_byte(struct i2c_client *client, u8 val)
> > > > +{
> > > > +	int ret;
> > > > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > > > +
> > > > +	mutex_lock(&data->lock);
> > > > +	ret = i2c_smbus_write_byte(client, val);
> > > > +	mutex_unlock(&data->lock);
> > > > +
> > > > +	return ret;
> > > > +}
> > >
> > > Didn't we ask you to remove these?  Just make the i2c_smbus_* calls
> > > from within the driver.  The I2C subsystem conducts its own locking.
> > > I'm really starting to frown on aggregation for the sake of
> > > aggregation.  It's just overhead.
> > >
> > 
> > Correct me if I'm wrong but as far as I remember Guenther asked to retain the
> > original API, not the remove the "abstraction layer". Once we build a board with
> > one of these BMCs attached via e.g. SPI we would have to reintroduce it anyways,
> > in order to re-use these drivers.
> 
> If there are two or more possible interfaces then I agree, these
> aggregations would be the best approach.  However, as it stands, that's
> not currently the case.
> 
> Genuine question; are Men on the verge of building such a board, or
> are we talking about 'ifs' and 'maybes'?
>

I think it was a missunderstanding. I also thought that i just
have to adapt the wrapper to the original API, that is what I did in the patch,
and not to delete the functions completly.

Anayway, we currently have another project which use a STM32 MCR connected to USB.
A nice feature of this STM is to update the firmware using the USB interface.
This is easy to implement and fast.

We want to use such a functionality in all of our MCRs to easily update the firmware
at the customer if we found a bug.

We also plan to have a BMC connected to USB. Then we have i2c and USB.

Regards
Andy

 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
