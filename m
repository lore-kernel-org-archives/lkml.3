Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaKZJNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:13:54 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36257 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZJNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <54754364.80705@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
	<5474A72D.2000309@roeck-us.net>
	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
	<5474B564.9080902@roeck-us.net>
	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
	<5474C36C.1020004@roeck-us.net>
	<CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com>
	<5474CAC6.8030608@roeck-us.net>
	<54754364.80705@roeck-us.net>
Date: Wed, 26 Nov 2014 10:13:50 +0100
Message-ID: <CAMpxmJWJzRaZeCuZJWZq0ukVLiSU2crUbWchP-PJtV85CvZM3g@mail.gmail.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 4:05 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> On 11/25/2014 10:30 AM, Guenter Roeck wrote:
>> Repeating my earlier question: Is the resistor value changed by software
>> or by changing the probe ?
>>
>
> Looking into the available documents, I am quite sure that the resistor
> is changed by replacing the probe, in other words by pulling the board
> with the ina226 and replacing it with another one. Given that, configuring
> the shunt resistor value with a sysfs attribute is really the wrong way
> to do it; you should use probe specific devicetree overlays instead.

Yes, it's changed by replacing the probes.

As for the averaging rate: it's a programmable feature of the chip and
it's useful for our user interface for noise reduction (or the
opposite - to be able to see the actual distortion), can this be
accepted after applying the fixes according to your review?

Bart
