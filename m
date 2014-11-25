Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKYQZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:25:34 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:42526 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaKYQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:25:32 -0500
MIME-Version: 1.0
In-Reply-To: <5474A72D.2000309@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
	<5474A72D.2000309@roeck-us.net>
Date: Tue, 25 Nov 2014 17:25:31 +0100
Message-ID: <CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
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

2014-11-25 16:58 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> You are introducing those two functions with the same code just to display
> a different error message. That does not provide enough value to have extra
> functions and just increases code size.
>
> Just check the return code from ina2xx_write_register directly in the probe
> function and bail out there.

With all six patches from this set applied, each of the two functions
is called twice in the code. Together with the return value checks and
repeated error messages it bloats the code even more. What about a
single function taking the name of the register (in our case
"configuration" or "calibration") as argument in order to print a nice
error message? If this is still too dirty, than we can just print the
hex value of the register.

Bart
