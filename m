Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbbAURGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:06:01 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34109 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbbAURFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:05:52 -0500
Message-ID: <54BFDC6B.30106@collabora.co.uk>
Date: Wed, 21 Jan 2015 18:05:47 +0100
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
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk> <20150120081104.GT21886@x1> <54BE7B08.1010900@collabora.co.uk> <20150120163410.GC30656@x1> <54BE87C4.4040108@collabora.co.uk>
In-Reply-To: <54BE87C4.4040108@collabora.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/20/2015 05:52 PM, Javier Martinez Canillas wrote:
>>> 
>>> Now, all those drivers may be wrong and the buses don't belong to the mfd
>>> subsystem but then I think we need to document that since it seems that is
>>> the correct way to do it just by looking at the other drivers.
>> 
>> I don't think the drivers you mentioned above do anything practical.
>> For instance, they are not SPI/IC2/etc drivers.  They should only
>> offer some abstraction layers which are used to communicate with the
>> device.  The driver you are submitting looks a lot more like a device
>> driver, which should live somewhere else.  Don't ask me where though,
>> I'm not even sure what a Low Pin Controller does.
>> 
> 
> The driver added by $subject doesn't really do anything practical either.
> LPC [0] is just another transport method like i2c or spi that is used on
> x86 Chromebooks to access the Embedded Controller.
> 
> So the driver is really not that different than the cros_ec_{i2c,spi}.c
> drivers.
> 
> Best regards,
> Javier
> 
> [0]: http://en.wikipedia.org/wiki/Low_Pin_Count
> 

Maybe the problem is that the commit message didn't explain this clearly?
I took the patch from the ChromiumOS tree verbatim but I can reword the
commit message to add something like this instead:

Author: Bill Richardson <wfrichar@chromium.org>
Date:   Tue Dec 23 15:13:23 2014 +0100

    mfd: cros_ec: Add cros_ec_lpc driver for x86 devices
    
    Chromebooks have an Embedded Controller (EC) that is used to
    implement various functions such as keyboard, power and battery.
    
    The AP can communicate with the EC through different bus types
    such as I2C, SPI or LPC.
    
    The cros_ec mfd driver is then composed of a core driver that
    register the sub-devices as mfd cells and provide a high level
    communication interface that is used by the rest of the kernel
    and bus specific interfaces modules.
    
    Each connection method then has its own driver, which register
    with the EC driver interface-agnostic interface.
    
    Currently, there are drivers to communicate with the EC over
    I2C and SPI and this driver adds support for LPC.
    
    Signed-off-by: Bill Richardson <wfrichar@chromium.org>
    Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>


If you agree with this commit message then I can change it on the next revision
but really $subject doesn't do anything special besides providing a transport
method to access the mfd device using a LPC bus.

Best regards,
Javier
