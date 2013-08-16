Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3HPWao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:30:44 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:39061 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab3HPWak convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:30:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1376680094!14491222!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "kernel@savoirfairelinux.com" <kernel@savoirfairelinux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 16 Aug 2013 14:06:24 -0500
Subject: RE: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
Thread-Topic: [PATCH] gpio: (gpio-pca953x) move header to
 linux/platform_data/
Thread-Index: Ac6akdA6Qk5q0sqBR4ykcmbeIG4QTgAIUdlA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC7DA184@AUSP01VMBX24.collaborationhost.net>
References: <CACRpkdZdeVNtJSmc6Lr6j=oO9FLsAvjyrwhYS0j4OoAEhxCN9g@mail.gmail.com>
 <82440653.410050.1376665340121.JavaMail.root@mail>
In-Reply-To: <82440653.410050.1376665340121.JavaMail.root@mail>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 16, 2013 8:02 AM, Vivien Didelot wrote:
> Hi Linus,
>
> You wrote:
> > But:
>>
>>>  drivers/gpio/gpio-pca953x.c                 |  2 +-
>> (...)
>>> diff --git a/drivers/gpio/gpio-pca953x.c
>>> b/drivers/gpio/gpio-pca953x.c
>>> index 426c51d..8804aec 100644
>>> --- a/drivers/gpio/gpio-pca953x.c
>>> +++ b/drivers/gpio/gpio-pca953x.c
>>> @@ -18,7 +18,7 @@
>>>  #include <linux/irq.h>
>>>  #include <linux/irqdomain.h>
>>>  #include <linux/i2c.h>
>>> -#include <linux/i2c/pca953x.h>
>>> +#include <linux/platform_data/pca953x.h>
>> 
>> Why does the GPIO driver need platform data from the
>> I2C driver???
>> 
>> Can't this just be made to go away?
>
> I didn't dig that much in the driver, but I cannot imagine
> another way to pass, for instance, the setup callback.
>
> What would be a good alternative for you?

I think the confusion here is because the pca953x.h header was initially
placed in linux/i2c.

This device is an I2C connected GPIO expander. The pca953x.h header has
the information needed for the platform to hook up to the device. It doesn't
really expose the fact that it's an I2C driver.

Just by 2 cents...
Hartley
