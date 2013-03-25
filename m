Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3CYGyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:54:15 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64025 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3CYGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <514F83F8.9000604@fold.natur.cuni.cz>
References: <20130323114011.GA11092@amd.pavel.ucw.cz>
	<87zjxu9spk.fsf@nemi.mork.no>
	<20130323202155.GC18732@amd.pavel.ucw.cz>
	<6726347.ehkcE9iAxU@vostro.rjw.lan>
	<20130324092733.GA3071@amd.pavel.ucw.cz>
	<514F83F8.9000604@fold.natur.cuni.cz>
Date: Mon, 25 Mar 2013 14:54:10 +0800
Message-ID: <CAOLK0pxtpgDdvHFRMDw3791HjWrF0wiheLv4oVW_cg2SVCrLqQ@mail.gmail.com>
Subject: Re: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        kernel list <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25 Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>:
>
>
> Pavel Machek wrote:
>> Hi!
>>
>>>>>>> pavel@amd:~$ cat /proc/acpi/battery/BAT0/info
>>>>>>> present:                 yes
>>>>>>> design capacity:         0 mWh
>>>>>>> last full capacity:      0 mWh
>>>>>>> battery technology:      rechargeable
>>>>>>> design voltage:          14400 mV
>>>>>>>
>>>>>>> This worked before... at least it works in 2.6 kernel used by debian.
>>>>>>
>>>>>> This works for me in 3.9-rc3.  May I see your .config?
>> ...
>>>> But problem is not in /proc, /sys has zeros, too.
>>>>
>>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full
>>>> 0
>>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full_design
>>>> 0
>>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/model_name
>>>> 93P5030
>>>> pavel@amd:~$
>>>
>>> Can you narrow the time frame when it stopped working a bit?
>>
>> Well, 2.6.32 from debian works ok, and self-compiled 3.1+ kernel also
>> seems to work ok.
>>
>> I'm not sure if 3.7+ kernels worked, actually... I'd have to do some
>> compiling to check.
>
> FYI, on 3.7.10 I don't have the above files. See below what I do have:
>
> # for f in /sys/class/power_supply/BAT0/*; do echo $f; cat $f; done
> /sys/class/power_supply/BAT0/alarm
> 0
> /sys/class/power_supply/BAT0/capacity
> 106
> /sys/class/power_supply/BAT0/charge_full
> 4126000
> /sys/class/power_supply/BAT0/charge_full_design
> 4400000
> /sys/class/power_supply/BAT0/charge_now
> 4400000
> /sys/class/power_supply/BAT0/current_now
> 1000
> /sys/class/power_supply/BAT0/cycle_count
> 0
> /sys/class/power_supply/BAT0/device
> cat: /sys/class/power_supply/BAT0/device: Is a directory
> /sys/class/power_supply/BAT0/manufacturer
> SMP
> /sys/class/power_supply/BAT0/model_name
> DELL 8NH551B
> /sys/class/power_supply/BAT0/power
> cat: /sys/class/power_supply/BAT0/power: Is a directory
> /sys/class/power_supply/BAT0/present
> 1
> /sys/class/power_supply/BAT0/serial_number
>  2630
> /sys/class/power_supply/BAT0/status
> Full
> /sys/class/power_supply/BAT0/subsystem
> cat: /sys/class/power_supply/BAT0/subsystem: Is a directory
> /sys/class/power_supply/BAT0/technology
> Li-ion
> /sys/class/power_supply/BAT0/type
> Battery
> /sys/class/power_supply/BAT0/uevent
> POWER_SUPPLY_NAME=BAT0
> POWER_SUPPLY_STATUS=Full
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_TECHNOLOGY=Li-ion
> POWER_SUPPLY_CYCLE_COUNT=0
> POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11100000
> POWER_SUPPLY_VOLTAGE_NOW=12294000
> POWER_SUPPLY_CURRENT_NOW=1000
> POWER_SUPPLY_CHARGE_FULL_DESIGN=4400000
> POWER_SUPPLY_CHARGE_FULL=4126000
> POWER_SUPPLY_CHARGE_NOW=4400000
> POWER_SUPPLY_CAPACITY=106
> POWER_SUPPLY_MODEL_NAME=DELL 8NH551B
> POWER_SUPPLY_MANUFACTURER=SMP
> POWER_SUPPLY_SERIAL_NUMBER= 2630
> /sys/class/power_supply/BAT0/voltage_min_design
> 11100000
> /sys/class/power_supply/BAT0/voltage_now
> 12294000
> #
Hi Martin:
               Thanks to report the bug.
               Both  charge_full_design  and  energy_full_design
indicate the battery Design Capacity.
Their difference is unit.  charge_full_design uses "mAh".
energy_full_design uses "mWh". The
same for charge_full and energy_full.
               So from this output, it still works on the v3.7+. Could
you continue narrow
the time frame?
              Which version you found the issue? could you provide the
output of dmesg
on it and acpidump? They will give us more clues since acpi battery
driver just exposes
data from Bios. Thanks in advance.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
