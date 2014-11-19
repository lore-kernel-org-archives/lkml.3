Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaKSRae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:30:34 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34442 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbaKSRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:30:32 -0500
Message-ID: <546CD3A0.6000307@gmail.com>
Date: Wed, 19 Nov 2014 23:00:08 +0530
From: Victor Ascroft <victorascroft@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mason <mpeg.blue@free.fr>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr> <546CCBF6.7070607@gmail.com> <546CD11F.6050502@free.fr>
In-Reply-To: <546CD11F.6050502@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/19/2014 10:49 PM, Mason wrote:
> On 19/11/2014 17:57, Victor Ascroft wrote:
> 
>> This actually depends on the kernel you are using. Do you have relatively
>> new kernel or an old one? Depending on that, either you will get that
>> information in a board file or else in the device tree in arch/arm/boot/dts.
> 
> I'll reply more thoroughly later, but I wanted to address this question.
> We're targeting kernel 3.14.x

OK. Has to be a device tree then.

> 
>> This depends. If you have driver compiled in with the kernel this will happen
>> on kernel boot up. If you have the driver as a loadable module, the probe hook
>> will be called on modprobe or insmod.
> 
> Is this an answer to question 5?
> I think there is some confusion with the "probe" terminology.
> 
> I meant "probe" as in "read the current value".
> I think you mean "probe" as in "the driver probes for the device through
> the probe method."
> 
> I meant to ask how often the hwmon framework "polls" the temperature sensor.

Oh. My understanding was you meant the "probe" of the driver. The hwmon
will be exposing the functionality of reading the temperature sensor through
a sysfs interface. I am not sure as to whether a "poll" functionality is
provided by hwmon (probably not), but, when you cat or read the sysfs path 
you will have the temperature readout. The lm75.c is good place to start.

http://lxr.free-electrons.com/source/Documentation/hwmon/
http://lxr.free-electrons.com/source/Documentation/hwmon/sysfs-interface

-- Sanchayan
> 
> Regards.
> 
