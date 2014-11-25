Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKYHiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:38:21 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51607 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYHiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:38:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141119100954.GV27002@pengutronix.de>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
 <1360738983-22436-3-git-send-email-gnurou@gmail.com> <20141117090915.GE27002@pengutronix.de>
 <CAAVeFuKzP0ADix8TxC31ohb3ZmnEVmNcO5kgzhZ3DcwAhTq=-Q@mail.gmail.com>
 <20141119084432.GT27002@pengutronix.de> <CAAVeFuLtQoxt_D_TaRQc49Sh0FZTg=q4y5QorZ7OUK+qPE0CbQ@mail.gmail.com>
 <20141119090222.GU27002@pengutronix.de> <CAAVeFu+zc6tiM-SvwQ3mQmkMNdY+1+Ysi0F2eThyCjziKVwpOQ@mail.gmail.com>
 <20141119100954.GV27002@pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 25 Nov 2014 16:37:57 +0900
Message-ID: <CAAVeFuJ8=PdV8oiazVVcyrO3Kx4mV6GphxHCGEGX9ooMuoBWtA@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpiolib: use const parameters when possible
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Janusz Uzycki <j.uzycki@elproma.com.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 7:09 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello Alexandre,
>
> On Wed, Nov 19, 2014 at 06:07:50PM +0900, Alexandre Courbot wrote:
>>  On Wed, Nov 19, 2014 at 6:02 PM, Uwe Kleine-König
>> <u.kleine-koenig@pengutronix.de> wrote:
>> > I'd make gpiod_get_direction static and only use it to fill in
>> > /sys/kernel/debug/gpio.
>>
>> That's very tempting. I see only atmel_serial.c using this function,
>> and there is no gpio_get_direction() declared anywhere so no user of
>> this either. I'm not sure what I was thinking when I decided to export
>> it?
> In next there is also drivers/tty/serial/mxs-auart.c.

Ok. I think we can get rid of gpiod_get_direction() if
serial_mctrl_gpio implements its own way to query the direction (maybe
using a bitmap in the mctrl_gpios and a mctrl_gpio_get_direction()
function that queries that map). Using gpiod_get_direction() is just
too unreliable.

Janusz, since your change for mxs-auart is in -next, would you mind
amending it to do this? Then we could do the same for atmel_serial and
remove gpiod_get_direction() from the public GPIO interface. This
function would do more harm than good anyway.

Thanks!
