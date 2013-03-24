Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3CXWxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 18:53:48 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:36817 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754872Ab3CXWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 18:53:46 -0400
Message-ID: <514F83F8.9000604@fold.natur.cuni.cz>
Date: Sun, 24 Mar 2013 23:53:44 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        kernel list <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
References: <20130323114011.GA11092@amd.pavel.ucw.cz> <87zjxu9spk.fsf@nemi.mork.no> <20130323202155.GC18732@amd.pavel.ucw.cz> <6726347.ehkcE9iAxU@vostro.rjw.lan> <20130324092733.GA3071@amd.pavel.ucw.cz>
In-Reply-To: <20130324092733.GA3071@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Machek wrote:
> Hi!
> 
>>>>>> pavel@amd:~$ cat /proc/acpi/battery/BAT0/info 
>>>>>> present:                 yes
>>>>>> design capacity:         0 mWh
>>>>>> last full capacity:      0 mWh
>>>>>> battery technology:      rechargeable
>>>>>> design voltage:          14400 mV
>>>>>>
>>>>>> This worked before... at least it works in 2.6 kernel used by debian.
>>>>>
>>>>> This works for me in 3.9-rc3.  May I see your .config?
> ...
>>> But problem is not in /proc, /sys has zeros, too.
>>>
>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full
>>> 0
>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full_design 
>>> 0
>>> pavel@amd:~$ cat /sys/class/power_supply/BAT0/model_name 
>>> 93P5030
>>> pavel@amd:~$
>>
>> Can you narrow the time frame when it stopped working a bit?
> 
> Well, 2.6.32 from debian works ok, and self-compiled 3.1+ kernel also
> seems to work ok.
> 
> I'm not sure if 3.7+ kernels worked, actually... I'd have to do some
> compiling to check.

FYI, on 3.7.10 I don't have the above files. See below what I do have:

# for f in /sys/class/power_supply/BAT0/*; do echo $f; cat $f; done
/sys/class/power_supply/BAT0/alarm
0
/sys/class/power_supply/BAT0/capacity
106
/sys/class/power_supply/BAT0/charge_full
4126000
/sys/class/power_supply/BAT0/charge_full_design
4400000
/sys/class/power_supply/BAT0/charge_now
4400000
/sys/class/power_supply/BAT0/current_now
1000
/sys/class/power_supply/BAT0/cycle_count
0
/sys/class/power_supply/BAT0/device
cat: /sys/class/power_supply/BAT0/device: Is a directory
/sys/class/power_supply/BAT0/manufacturer
SMP
/sys/class/power_supply/BAT0/model_name
DELL 8NH551B
/sys/class/power_supply/BAT0/power
cat: /sys/class/power_supply/BAT0/power: Is a directory
/sys/class/power_supply/BAT0/present
1
/sys/class/power_supply/BAT0/serial_number
 2630
/sys/class/power_supply/BAT0/status
Full
/sys/class/power_supply/BAT0/subsystem
cat: /sys/class/power_supply/BAT0/subsystem: Is a directory
/sys/class/power_supply/BAT0/technology
Li-ion
/sys/class/power_supply/BAT0/type
Battery
/sys/class/power_supply/BAT0/uevent
POWER_SUPPLY_NAME=BAT0
POWER_SUPPLY_STATUS=Full
POWER_SUPPLY_PRESENT=1
POWER_SUPPLY_TECHNOLOGY=Li-ion
POWER_SUPPLY_CYCLE_COUNT=0
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11100000
POWER_SUPPLY_VOLTAGE_NOW=12294000
POWER_SUPPLY_CURRENT_NOW=1000
POWER_SUPPLY_CHARGE_FULL_DESIGN=4400000
POWER_SUPPLY_CHARGE_FULL=4126000
POWER_SUPPLY_CHARGE_NOW=4400000
POWER_SUPPLY_CAPACITY=106
POWER_SUPPLY_MODEL_NAME=DELL 8NH551B
POWER_SUPPLY_MANUFACTURER=SMP
POWER_SUPPLY_SERIAL_NUMBER= 2630
/sys/class/power_supply/BAT0/voltage_min_design
11100000
/sys/class/power_supply/BAT0/voltage_now
12294000
#
