Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLKK0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:26:11 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52045 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141210183146.GA22847@roeck-us.net>
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com>
	<1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
	<548856AF.8090805@roeck-us.net>
	<CAMpxmJXp2NT+rie2d2+Z7hixKMyS+xcRNdKRNZaUSJD-aTUVVg@mail.gmail.com>
	<20141210183146.GA22847@roeck-us.net>
Date: Thu, 11 Dec 2014 11:26:07 +0100
Message-ID: <CAMpxmJXVPbp+XJQ9oVpAB3ejRx7Czb0KTC0HtfL9zed4Z_rOQA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] hwmon: ina2xx: make shunt resistance configurable
 at run-time
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-10 19:31 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> I don't really want it at all ;-). Seems to me all those options are broken
> one way or another. The only real solution would be to re-instantiate the
> driver if the chip was removed and re-inserted, and to provide parameters
> either with platform data or with devicetree data.

I see your point, but as Benoit mentioned in one of the previous
messages, in case of our platform it would be impossible to have an
exhaustive list of possible shunt values.

> On a side note, data->rshunt is not really needed anymore with your current
> code. The only reason for storing it in data is to use it in
> ina2xx_calibration_val(), but you could as well pass it in as parameter
> to that function. Even better would be to have a function such as
> ina2xx_calibrate() and let it handle the write to the calibration register.
> Also, I would suggest to move the above code into its own show function.
> It is probably not a good idea to have a single function for all those
> conversions in the first place, and converting from 'calibration' to
> rshunt goes a bit beyond the original intent to convert from one representation
> to the other.

I agree about having separate functions for this parameter and about
not needing data->rshunt in my current code, but we still aren't clear
about whether to read the value from the register or to store it in
memory.

> That still doesn't really solve the structural problem of having to deal with
> an uninitialized chip which doesn't like to be uninitialized. But then on the
> other side I guess that is really a problem with your platform, not a driver
> problem.

This might be a stupid idea, but what about reading the calibration
register first in ina2xx_update_device() and, in case it's value is 0
(POR value according to the datasheet), reinitializing the chip?

Bart
