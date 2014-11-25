Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaKYSWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:22:25 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49135 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <5474C36C.1020004@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
	<5474A72D.2000309@roeck-us.net>
	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
	<5474B564.9080902@roeck-us.net>
	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
	<5474C36C.1020004@roeck-us.net>
Date: Tue, 25 Nov 2014 19:22:23 +0100
Message-ID: <CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com>
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

2014-11-25 18:59 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> It seems to me this is a problem of your architecture. That doesn't
> make it a generic problem. Your architecture should detect that a
> probe was disconnected and de-instantiate the device automatically
> if so, and re-instantiate it if it is re-inserted. Ultimately this
> should be done with, for example, devicetree overlays.

You're right and it's planned to be done this way in the future, when
this project exits its prototype phase (around Q2 2015). Nevertheless
I still think that if we're adding a set function, it should behave
like the getters and check the value returned by
i2c_smbus_write_word_swapped().

Bart
