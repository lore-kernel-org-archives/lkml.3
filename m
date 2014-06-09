Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaFISgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:36:52 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38371 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaFISgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:36:49 -0400
Message-ID: <5395FEBF.3040608@cogentembedded.com>
Date: Mon, 09 Jun 2014 22:36:47 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Sascha Silbe <x-linux@infra-silbe.de>
CC: Johan Hovold <jhovold@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de> <20140609152313.45f353d6@alan.etchedpixels.co.uk>
In-Reply-To: <20140609152313.45f353d6@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/09/2014 06:23 PM, One Thousand Gnomes wrote:

>>   #include <linux/kernel.h>
>>   #include <linux/errno.h>
>> +#ifdef CONFIG_GPIOLIB
>> +#include <linux/gpio.h>
>> +#endif

> Please create a new struct, a new file and put all the GPIO stuff in
> there rather than #if bombing the driver.

> You can then declare blank methods for the gpio stuff if GPIO is not
> compiled in - ie in the headers

> #ifdef CONFIG_GPIOLIB
> extern int ftdi_gpio_open(struct ftdi_private *priv);
> etc...
> #else
> extern inline  int ftdi_gpio_open(struct ftdi_private *priv) { return 0 };

    I guess you meant *static* instead of *extern* here?

> #endif

WBR, Sergei

