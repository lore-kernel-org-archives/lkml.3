Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCHXwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:52:07 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61743 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaCHXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:50:51 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <531BACD9.9050206@roeck-us.net>
Date: Sat, 08 Mar 2014 15:50:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laszlo Papp <lpapp@kde.org>
CC: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Tachometer speed returned rather than absolute fan
 speed?
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>	<20140307162524.6abd34be@endymion.delvare>	<CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>	<20140307163717.336873f5@endymion.delvare>	<CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com> <20140307181718.GA1027@roeck-us.net>
In-Reply-To: <20140307181718.GA1027@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 10:17 AM, Guenter Roeck wrote:
> On Fri, Mar 07, 2014 at 03:47:08PM +0000, Laszlo Papp wrote:
>> On Fri, Mar 7, 2014 at 3:37 PM, Jean Delvare <jdelvare@suse.de> wrote:
>>>>> I'm quite confused. While I admit that the term "tachometer speed" is
>>>>> awkward, the max6650 driver is reporting fan speeds in RPM as every
>>>>> other hwmon driver. So I really have no idea what you think is wrong.
>>>>> What did you think "tachometer speed" was, if not the fan speed? Does
>>>>> the max6650 driver not return correct fan speeds for you?
>>
>> That is some strange behavior. If I do "echo 1 > pwm1_enable; echo 0 >
>> pwm1; cat fan1_input", I still see 30 for the connected fan, whereas I
>> can see it stopped. Is this an expected behavior? I would expect zero
>> as a user.
>>
> I seem to recall that I had seen that as well, with no fan connected.
> Maybe the tachometer registers always read at least '1'. I would think
> it is wrong, but we'll have to understand the chip a bit better
> to be able to provide a fix. Unless you already have a fix ready,
> of course. I'll try to re-test tonight if I find the time.
>

The reason is (most likely) that your fan input does not have a pull-up
resistor. Per datasheet, the fan inputs need a 10kOhm pull-up resistor.
I confirmed this with my test board - with the pull-up resistor,
inputs read 0, Without pull-up, the reported value is 1, which
translates to 30 RPM.

You might also need the 10 uF capacitor on the FB pin.

Guenter

