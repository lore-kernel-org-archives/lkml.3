Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbbAVJqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:46:31 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56176 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbbAVJqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:46:16 -0500
Date: Thu, 22 Jan 2015 09:46:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH RESEND v2 3/7] mfd: cros_ec: Add cros_ec_lpc driver for
 x86 devices
Message-ID: <20150122094608.GA5769@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk>
 <20150120081104.GT21886@x1>
 <54BE7B08.1010900@collabora.co.uk>
 <20150120163410.GC30656@x1>
 <54BE87C4.4040108@collabora.co.uk>
 <20150122084244.GP22024@x1>
 <54C0BE21.7020008@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C0BE21.7020008@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> On 01/22/2015 09:42 AM, Lee Jones wrote:
> >> > 
> >> > I don't think the drivers you mentioned above do anything practical.
> >> > For instance, they are not SPI/IC2/etc drivers.  They should only
> >> > offer some abstraction layers which are used to communicate with the
> >> > device.  The driver you are submitting looks a lot more like a device
> >> > driver, which should live somewhere else.  Don't ask me where though,
> >> > I'm not even sure what a Low Pin Controller does.
> >> > 
> >> 
> >> The driver added by $subject doesn't really do anything practical either.
> >> LPC [0] is just another transport method like i2c or spi that is used on
> >> x86 Chromebooks to access the Embedded Controller.
> > 
> > I'm not sure that's true.  It's pretty simple I grant you, but it
> > still looks like a driver, rather than an abstraction layer.
> > 
> > I would expect to see something more like:
> > 
> > static int cros_ec_lpc_readmem(...)
> > {
> > 	return call_to_driver_to_read_memory(...);
> > 	
> > }
> > 
> > ... instead of all those memory/register reads/writes.
> >
> 
> Yeah... in that sense I've to admit that is more complex than the I2C and SPI
> drivers, yet those have a subsystem in the kernel with helpers functions to
> do most of the communication:
> 
> static int cros_ec_cmd_xfer_i2c(struct cros_ec_device *ec_dev,
> 				struct cros_ec_command *msg)
> {
> ...
> 	ret = i2c_transfer(client->adapter, i2c_msg, 2);
> ...
> }
> 
> static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
> 				struct cros_ec_command *ec_msg)
> {
> ...
> 	spi_message_add_tail(&trans, &msg);
> 	ret = spi_sync(ec_spi->spi, &msg);
> ...
> }
> 
> But there doesn't seem to be a LPC subsystem in the kernel so we don't have a
> nice abstraction layer in this case.

This is the crux of the problem.  However, I feel bad for MFD, as it
is, once more, being used as an "well it doesn't fit anywhere else, so
let's shoehorn it in there" type of dumping ground.

> > Are there any other Low Pin Count drivers in the kernel?
> >
> 
> I don't know tbh, I didn't even know what LPC was before I picked this patch
> to push it upstream. I searched in the Linux codebase for other LPC drivers
> but I didn't find anything, that doesn't mean that it doesn't exist though.

I agree.  Perhaps a suitable driver should live in drivers/misc until
there are enough of them to warrant its own subsystem.

Anyone else have an opinion?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
