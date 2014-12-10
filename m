Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbaLJQqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:46:45 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52313 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaLJQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:46:44 -0500
MIME-Version: 1.0
In-Reply-To: <548856AF.8090805@roeck-us.net>
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com>
	<1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
	<548856AF.8090805@roeck-us.net>
Date: Wed, 10 Dec 2014 17:46:43 +0100
Message-ID: <CAMpxmJXp2NT+rie2d2+Z7hixKMyS+xcRNdKRNZaUSJD-aTUVVg@mail.gmail.com>
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

2014-12-10 15:20 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
>> +       case INA2XX_CALIBRATION:
>> +               if (data->regs[reg] == 0)
>> +                       val = 0;
>> +               else
>> +                       val = data->config->calibration_factor
>> +                                               / data->regs[reg];
>> +               break;
>
>
> This doesn't really make sense. What you want to show is rshunt, not the
> above.
> I think it would be better to write a separate show function to display it.

Hi Guenter,

this is the only way to display values read from the chip. It also
tells the user what the actual programmed value is. In fact it was
your suggestion (https://lkml.org/lkml/2014/11/30/233) and I agree
that it's a better alternative. Are you sure you don't want it done
this way?

Bart
