Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaKYJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:36:49 -0500
Received: from v032797.home.net.pl ([89.161.177.31]:52416 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750828AbaKYJgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:36:47 -0500
Message-ID: <54744DAB.1010603@elproma.com.pl>
Date: Tue, 25 Nov 2014 10:36:43 +0100
From: =?UTF-8?B?SmFudXN6IFXFvHlja2k=?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaQ==?= =?UTF-8?B?Zw==?= 
	<u.kleine-koenig@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 2/4] gpiolib: use const parameters when possible
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com> <1360738983-22436-3-git-send-email-gnurou@gmail.com> <20141117090915.GE27002@pengutronix.de> <CAAVeFuKzP0ADix8TxC31ohb3ZmnEVmNcO5kgzhZ3DcwAhTq=-Q@mail.gmail.com> <20141119084432.GT27002@pengutronix.de> <CAAVeFuLtQoxt_D_TaRQc49Sh0FZTg=q4y5QorZ7OUK+qPE0CbQ@mail.gmail.com> <20141119090222.GU27002@pengutronix.de> <CAAVeFu+zc6tiM-SvwQ3mQmkMNdY+1+Ysi0F2eThyCjziKVwpOQ@mail.gmail.com> <20141119100954.GV27002@pengutronix.de> <CAAVeFuJ8=PdV8oiazVVcyrO3Kx4mV6GphxHCGEGX9ooMuoBWtA@mail.gmail.com>
In-Reply-To: <CAAVeFuJ8=PdV8oiazVVcyrO3Kx4mV6GphxHCGEGX9ooMuoBWtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

W dniu 2014-11-25 o 08:37, Alexandre Courbot pisze:
> On Wed, Nov 19, 2014 at 7:09 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
>> Hello Alexandre,
>>
>> On Wed, Nov 19, 2014 at 06:07:50PM +0900, Alexandre Courbot wrote:
>>>   On Wed, Nov 19, 2014 at 6:02 PM, Uwe Kleine-König
>>> <u.kleine-koenig@pengutronix.de> wrote:
>>>> I'd make gpiod_get_direction static and only use it to fill in
>>>> /sys/kernel/debug/gpio.
>>> That's very tempting. I see only atmel_serial.c using this function,
>>> and there is no gpio_get_direction() declared anywhere so no user of
>>> this either. I'm not sure what I was thinking when I decided to export
>>> it?
>> In next there is also drivers/tty/serial/mxs-auart.c.
> Ok. I think we can get rid of gpiod_get_direction() if
> serial_mctrl_gpio implements its own way to query the direction (maybe
> using a bitmap in the mctrl_gpios and a mctrl_gpio_get_direction()
> function that queries that map). Using gpiod_get_direction() is just
> too unreliable.

good idea

>
> Janusz, since your change for mxs-auart is in -next, would you mind
> amending it to do this? Then we could do the same for atmel_serial and
> remove gpiod_get_direction() from the public GPIO interface. This
> function would do more harm than good anyway.

After a discussion I prepared RFC patch set to avoid the function.
You will find it here [1]:
("[RFC PATCH 1/2] serial: mctrl-gpio: Add irqs helpers for input lines")
("[RFC PATCH 2/2] serial: mxs-auart: use helpers for gpio irqs")
and the function was moved for debug only:
("[PATCH v3] gpio: mxs: implement get_direction callback")

Affected drivers by the patch set in the next are:
- atmel_serial
- mxs-auart
- clps711x (very basic usage)
The RFC patch set removes the inconvenient function from mxs-auart as 
example.
I didn't prepared a patch for atmel_serial because I wait for comments about
mctrl_gpio_is_gpio() function to differentiate if line is GPIO or native in
enable/disable_ms() callbacks.
I also can't test it for other devices than mxs (mx28).

[1] http://www.spinics.net/lists/arm-kernel/msg378444.html

best regards
Janusz

