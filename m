Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaKZJiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:38:22 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58864 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaKZJiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:38:20 -0500
Message-ID: <54759F8A.20303@baylibre.com>
Date: Wed, 26 Nov 2014 10:38:18 +0100
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>	<5474A72D.2000309@roeck-us.net>	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>	<5474B564.9080902@roeck-us.net>	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>	<5474C36C.1020004@roeck-us.net> <CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com> <5474CAC6.8030608@roeck-us.net> <54754364.80705@roeck-us.net>
In-Reply-To: <54754364.80705@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 26/11/2014 04:05, Guenter Roeck wrote:

[...]

> Looking into the available documents, I am quite sure that the resistor
> is changed by replacing the probe, in other words by pulling the board
> with the ina226 and replacing it with another one. Given that, configuring
> the shunt resistor value with a sysfs attribute is really the wrong way
> to do it; you should use probe specific devicetree overlays instead.

Unfortunately, that's not dynamic enough for all the use cases we need 
to support with the probes.
In fact, most customers will rather put the shunts on their board and 
thus use a shunt-less version of the probe to do the measurement. In 
that case, there is no way we can hard code, even in a DTS, the shunt value.

That's for that kind of usage that we do need to be able to set the 
shunt value at runtime. The probe in that case can be pluged dynamically 
on different board jumpers to do the measurement.

Later, thanks to the web UI, the user will be able to configure the 
shunt value based on the way they were plugged to its boards.

sysfs seems to be the easiest way to do that. I don't think DT overlay 
can handle that, since it is depend of the targeted system and not on 
the measurement system.

Thanks,
Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
