Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaLALAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:00:00 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaLAK76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:59:58 -0500
Message-ID: <547C4A26.3070108@nod.at>
Date: Mon, 01 Dec 2014 11:59:50 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        javier.martinez@collabora.co.uk, acourbot@nvidia.com,
        swarren@nvidia.com, jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iio: dht11 broken
References: <547B4464.9090300@nod.at> <E1XvOXs-00014Z-6F@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XvOXs-00014Z-6F@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 01.12.2014 um 11:49 schrieb Harald Geyer:
> Hi Richard!
> 
> Richard Weinberger writes:
>> Staring with 3.12 gpiolib refuses to set an GPIO used as IRQ into output mode.
>> see commit d468bf9e (gpio: add API to be strict about GPIO IRQ usage)
>> The dht driver does this and is therefore not functional.
>> As the dht11 driver got merged in 3.13 there is a high chance that it
>> never worked.
> 
> Well, I'm developing on mxs and there it works on 3.13 and 3.14 at least.
> (I have it in production using 3.14.18 ATM.)
>  
>> Harald, are you aware of this issue?
> 
> I got one report about this issue, but couldn't reproduce it yet and
> the reporter didn't agree to quoting his messages to kernel mailing lists,
> so this has been rather low priority on my todo list. Next plan is to
> see if I can reproduce the issue on sunxi (A10).

Not all gpio drivers use the new IRQ lock stuff.

> However anybody able to reproduce this and willing to test patches, would
> of course push this up on my todo list.
> 
> Any input from gpiolib people about what the proper fix would be in
> their opinion, of course is appreciated. I don't think the dht11 driver
> is doing anything unreasonable per se, so maybe they can clarify how
> the API is intended to be used?

Your driver sets up a GPIO as IRQ and then you switch the mode to output
to enable the DHT sensor.
This is not an API issue, it is an design issue.
I'm not a hardware expert but AFAIK setting an IRQ pin into output mode can
lead to undefined behavior.

Thanks,
//richard
