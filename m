Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaCXEPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:15:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65388 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaCXEPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:15:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532FB154.6020608@roeck-us.net>
Date: Sun, 23 Mar 2014 21:15:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Lu, Baolu" <baolu.lu@linux.intel.com>, linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [asus-nb-wmi] thermal device detected by asus-nb-wmi platform
 driver
References: <532B8630.8030607@linux.intel.com>
In-Reply-To: <532B8630.8030607@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 05:22 PM, Lu, Baolu wrote:
> Hi,
>
> I booted Ubuntu13.10 onto ASUS T100 Tablet and upgraded it with upstream
> kernel (3.14.0-rc7+). There is a thermal device under
> /sys/devices/platform/asus-nb-wmi.
>
> root@t100:~/linux# tree /sys/class/hwmon/
> /sys/class/hwmon/
> ├── hwmon0 -> ../../devices/platform/coretemp.0/hwmon/hwmon0
> └── hwmon1 -> ../../devices/platform/asus-nb-wmi/hwmon/hwmon1
>
> root@t100:/sys/devices/platform/asus-nb-wmi# ls
> cpufv driver hwmon input modalias power subsystem uevent
>
> root@t100:~/linux# sensors
> coretemp-isa-0000
> Adapter: ISA adapter
> Core 0: +38.0°C (high = +90.0°C, crit = +90.0°C)
> Core 1: +38.0°C (high = +90.0°C, crit = +90.0°C)
> Core 2: +39.0°C (high = +90.0°C, crit = +90.0°C)
> Core 3: +38.0°C (high = +90.0°C, crit = +90.0°C)
>
> asus-isa-0000
> Adapter: ISA adapter
> temp1: +6280.0°C
>

Pretty hot ;-). Not your problem, though - it looks like the temperature
is reported in Kelvin and the code converting from Kelvin to degrees C
turns out to be buggy.

> I didn't get any information about thermal interface in
> "Documentation/ABI/testing/sysfs-platform-asus-wmi". Is this a thermal
> sensor? If it's the fact, how can I change the environment so that this
> sensor gives me variable data?
>

I don't think I understand your question. Yes, this is a thermal sensor.
What is it you want to do (in addition to having it report reasonable
temperatures) ?

Guenter

