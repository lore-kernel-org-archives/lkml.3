Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbbATQw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:52:28 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60988 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbATQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:52:25 -0500
Message-ID: <54BE87C4.4040108@collabora.co.uk>
Date: Tue, 20 Jan 2015 17:52:20 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 3/7] mfd: cros_ec: Add cros_ec_lpc driver for
 x86 devices
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk> <20150120081104.GT21886@x1> <54BE7B08.1010900@collabora.co.uk> <20150120163410.GC30656@x1>
In-Reply-To: <20150120163410.GC30656@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/20/2015 05:34 PM, Lee Jones wrote:
>> 
>> So, the Embedded Controller driver (drivers/mfd/cros_ec.c) falls into that
>> category and in fact has been in the mfd driver for a long time. Now, if
>> an mfd device support different type of buses (e.g: i2c, spi, etc) I see
>> that both the core driver and the driver for the transport method are
>> in the drivers/mfd directory. As an example:
>> 
>> drivers/mfd/arizona-{core,i2c,spi}.c
>> drivers/mfd/da9052-{core,i2c,spi}.c
>> drivers/mfd/mc13xxx-{core,i2c,spi}.c
>> drivers/mfd/tps65912-{core,i2c,spi}.c
>> drivers/mfd/wm831x-{core,i2c,spi,otp}.c
>> 
>> In the cros_ec case, we already have drivers/mfd/cros_ec_{i2c,spi}.c so
>> since the Low Pin Count is another transport method I thought that this
>> driver belonged to the drivers/mfd directory.
>> 
>> Now, all those drivers may be wrong and the buses don't belong to the mfd
>> subsystem but then I think we need to document that since it seems that is
>> the correct way to do it just by looking at the other drivers.
> 
> I don't think the drivers you mentioned above do anything practical.
> For instance, they are not SPI/IC2/etc drivers.  They should only
> offer some abstraction layers which are used to communicate with the
> device.  The driver you are submitting looks a lot more like a device
> driver, which should live somewhere else.  Don't ask me where though,
> I'm not even sure what a Low Pin Controller does.
> 

The driver added by $subject doesn't really do anything practical either.
LPC [0] is just another transport method like i2c or spi that is used on
x86 Chromebooks to access the Embedded Controller.

So the driver is really not that different than the cros_ec_{i2c,spi}.c
drivers.

Best regards,
Javier

[0]: http://en.wikipedia.org/wiki/Low_Pin_Count
