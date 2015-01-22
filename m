Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbbAVInB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:43:01 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50908 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbAVImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:42:53 -0500
Date: Thu, 22 Jan 2015 08:42:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 3/7] mfd: cros_ec: Add cros_ec_lpc driver for
 x86 devices
Message-ID: <20150122084244.GP22024@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk>
 <20150120081104.GT21886@x1>
 <54BE7B08.1010900@collabora.co.uk>
 <20150120163410.GC30656@x1>
 <54BE87C4.4040108@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE87C4.4040108@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> On 01/20/2015 05:34 PM, Lee Jones wrote:
> >> 
> >> So, the Embedded Controller driver (drivers/mfd/cros_ec.c) falls into that
> >> category and in fact has been in the mfd driver for a long time. Now, if
> >> an mfd device support different type of buses (e.g: i2c, spi, etc) I see
> >> that both the core driver and the driver for the transport method are
> >> in the drivers/mfd directory. As an example:
> >> 
> >> drivers/mfd/arizona-{core,i2c,spi}.c
> >> drivers/mfd/da9052-{core,i2c,spi}.c
> >> drivers/mfd/mc13xxx-{core,i2c,spi}.c
> >> drivers/mfd/tps65912-{core,i2c,spi}.c
> >> drivers/mfd/wm831x-{core,i2c,spi,otp}.c
> >> 
> >> In the cros_ec case, we already have drivers/mfd/cros_ec_{i2c,spi}.c so
> >> since the Low Pin Count is another transport method I thought that this
> >> driver belonged to the drivers/mfd directory.
> >> 
> >> Now, all those drivers may be wrong and the buses don't belong to the mfd
> >> subsystem but then I think we need to document that since it seems that is
> >> the correct way to do it just by looking at the other drivers.
> > 
> > I don't think the drivers you mentioned above do anything practical.
> > For instance, they are not SPI/IC2/etc drivers.  They should only
> > offer some abstraction layers which are used to communicate with the
> > device.  The driver you are submitting looks a lot more like a device
> > driver, which should live somewhere else.  Don't ask me where though,
> > I'm not even sure what a Low Pin Controller does.
> > 
> 
> The driver added by $subject doesn't really do anything practical either.
> LPC [0] is just another transport method like i2c or spi that is used on
> x86 Chromebooks to access the Embedded Controller.

I'm not sure that's true.  It's pretty simple I grant you, but it
still looks like a driver, rather than an abstraction layer.

I would expect to see something more like:

static int cros_ec_lpc_readmem(...)
{
	return call_to_driver_to_read_memory(...);
	
}

... instead of all those memory/register reads/writes.

Are there any other Low Pin Count drivers in the kernel?

> So the driver is really not that different than the cros_ec_{i2c,spi}.c
> drivers.
> 
> Best regards,
> Javier
> 
> [0]: http://en.wikipedia.org/wiki/Low_Pin_Count

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
