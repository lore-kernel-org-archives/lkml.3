Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaCGPbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:31:47 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42833 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaCGPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140307162524.6abd34be@endymion.delvare>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
	<20140307162524.6abd34be@endymion.delvare>
Date: Fri, 7 Mar 2014 15:31:44 +0000
X-Google-Sender-Auth: 3wSJD4w07w34CPFLrGzW1W5WS18
Message-ID: <CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>
Subject: Re: Tachometer speed returned rather than absolute fan speed?
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 3:25 PM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Laszlo,
>
> On Fri, 7 Mar 2014 14:48:01 +0000, Laszlo Papp wrote:
>> In medias res, I find this interface cumbersome:
>> http://lxr.free-electrons.com/source/Documentation/hwmon/max6650#L31
>>
>> It returns tachometer speed rather than actual fan speed when you deal
>> with the fan1_target interface. That would be way more convenient for
>> end users like me.
>>
>> Is there any reason for not returning absolute fan speed? I guess,
>> this would break the behavior now. However, that would be a really
>> useful convenient feature. Is it possible to add a new interface for
>> that?
>
> I'm quite confused. While I admit that the term "tachometer speed" is
> awkward, the max6650 driver is reporting fan speeds in RPM as every
> other hwmon driver. So I really have no idea what you think is wrong.
> What did you think "tachometer speed" was, if not the fan speed? Does
> the max6650 driver not return correct fan speeds for you?

I was just writing a patch to improve the documentation. Tachometer
value is not equal to the fan speed, and using the terms together is
confusing. It should probably read as follows:

"absolute fan speed in RPM based on the corresponding tachometer
value" or something similar. I just did not get the meaning of two
different values together, and I think that confused me, especially
since get_fan and get_target are doing slightly different
computations, so it took me a while to figure this out from the
datasheet.

Better wording would have definitely helped in here. Fwiw, I asked
another kernel hacker person who also got confused telling me that he
would not know without reading the source code. I think that it is an
indication to improve the documentation. There might be better
alternatives than the one I am proposing, but at least that one clears
up that for me.
