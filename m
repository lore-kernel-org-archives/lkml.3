Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3E3Bzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:55:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64462 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777Ab3E3Bze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <19316305.cljVYtP0Hv@vostro.rjw.lan>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com>
	<2968280.mrRQeH7SYv@vostro.rjw.lan>
	<CAE9FiQV8CZN+mQvZScr16y9R1y6Tyx7uQg_DbNwE5KkHdi5H1w@mail.gmail.com>
	<19316305.cljVYtP0Hv@vostro.rjw.lan>
Date: Wed, 29 May 2013 18:55:33 -0700
X-Google-Sender-Auth: VzSrno-BUbKHezyMM4Z9nFNsYu8
Message-ID: <CAE9FiQWroCPOitz-k0h5Rm2+qqBitAySE7m6fqaKmzA+xdJn1w@mail.gmail.com>
Subject: Re: System slow down from udev
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 4:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, May 29, 2013 03:49:38 PM Yinghai Lu wrote:
>> On Wed, May 29, 2013 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Wednesday, May 29, 2013 01:13:46 PM Yinghai Lu wrote:
>> >> On Wed, May 29, 2013 at 4:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > On your systems the processor driver is built-in.  Any chance to build it as
>> >> > a module and see if that helps?
>> >>
>> >> it CONFIG_ACPI_PROCESSOR it not set in the config
>> >> the boot get to normal speed.
>> >
>> > Well, if it is not set at all, there won't be problems with it. :-)
>> >
>> > I've tested my linux-next branch on OpenSUSE 11.3 both with the processor
>> > driver built in and modular and I'm not able to reproduce the issue you're
>> > seeing.
>> >
>> > Moreover, I'm not sure if user space is involved here at all, because the
>> > problem triggers for you when all of the relevant kernel code is non-modular.
>> >
>> > With the processor driver enabled, when the slowdown happens, are the systems
>> > usable enough to get some debug info out of them?
>>
>> please check the bootchart data.
>>
>> looks like it take 200s if no acpi_processor ...
>> otherwise will take 800s or more.
>
> Well, something's fishy for sure.
>
> To my eyes it looks like we're getting lots of notifications related to the
> processor driver and that generates a lot of workqueue load.
>
> Can you please get /proc/interrupts from both cases and the output of
> "find /sys/firmware/acpi/interrupts/ -print -exec cat {} \;"?

sca05-0a818ce5:~/g5_acpi_driver # find /sys/firmware/acpi/interrupts/
-print -exec cat {} \;
/sys/firmware/acpi/interrupts/
cat: /sys/firmware/acpi/interrupts/: Is a directory
/sys/firmware/acpi/interrupts/sci
       0
/sys/firmware/acpi/interrupts/error
       0
/sys/firmware/acpi/interrupts/gpe00
       0   invalid
/sys/firmware/acpi/interrupts/gpe01
       0   invalid
/sys/firmware/acpi/interrupts/gpe02
       0   invalid
/sys/firmware/acpi/interrupts/gpe03
       0   disabled
/sys/firmware/acpi/interrupts/gpe04
       0   disabled
/sys/firmware/acpi/interrupts/gpe05
       0   disabled
/sys/firmware/acpi/interrupts/gpe06
       0   invalid
/sys/firmware/acpi/interrupts/gpe07
       0   invalid
/sys/firmware/acpi/interrupts/gpe08
       0   invalid
/sys/firmware/acpi/interrupts/gpe09
       0   disabled
/sys/firmware/acpi/interrupts/gpe10
       0   invalid
/sys/firmware/acpi/interrupts/gpe11
       0   invalid
/sys/firmware/acpi/interrupts/gpe12
       0   invalid
/sys/firmware/acpi/interrupts/gpe13
       0   invalid
/sys/firmware/acpi/interrupts/gpe14
       0   invalid
/sys/firmware/acpi/interrupts/gpe15
       0   invalid
/sys/firmware/acpi/interrupts/gpe16
       0   invalid
/sys/firmware/acpi/interrupts/gpe0A
       0   enabled
/sys/firmware/acpi/interrupts/gpe17
       0   invalid
/sys/firmware/acpi/interrupts/gpe0B
       0   disabled
/sys/firmware/acpi/interrupts/gpe18
       0   invalid
/sys/firmware/acpi/interrupts/gpe0C
       0   disabled
/sys/firmware/acpi/interrupts/gpe19
       0   invalid
/sys/firmware/acpi/interrupts/gpe0D
       0   disabled
/sys/firmware/acpi/interrupts/gpe0E
       0   disabled
/sys/firmware/acpi/interrupts/gpe20
       0   disabled
/sys/firmware/acpi/interrupts/gpe0F
       0   invalid
/sys/firmware/acpi/interrupts/gpe21
       0   invalid
/sys/firmware/acpi/interrupts/gpe22
       0   invalid
/sys/firmware/acpi/interrupts/gpe23
       0   invalid
/sys/firmware/acpi/interrupts/gpe24
       0   invalid
/sys/firmware/acpi/interrupts/gpe25
       0   invalid
/sys/firmware/acpi/interrupts/gpe26
       0   invalid
/sys/firmware/acpi/interrupts/gpe1A
       0   invalid
/sys/firmware/acpi/interrupts/gpe27
       0   invalid
/sys/firmware/acpi/interrupts/gpe1B
       0   disabled
/sys/firmware/acpi/interrupts/gpe28
       0   invalid
/sys/firmware/acpi/interrupts/gpe1C
       0   invalid
/sys/firmware/acpi/interrupts/gpe29
       0   invalid
/sys/firmware/acpi/interrupts/gpe1D
       0   invalid
/sys/firmware/acpi/interrupts/gpe1E
       0   invalid
/sys/firmware/acpi/interrupts/gpe30
       0   invalid
/sys/firmware/acpi/interrupts/gpe1F
       0   invalid
/sys/firmware/acpi/interrupts/gpe31
       0   invalid
/sys/firmware/acpi/interrupts/gpe32
       0   invalid
/sys/firmware/acpi/interrupts/gpe33
       0   invalid
/sys/firmware/acpi/interrupts/gpe34
       0   invalid
/sys/firmware/acpi/interrupts/gpe35
       0   invalid
/sys/firmware/acpi/interrupts/gpe36
       0   invalid
/sys/firmware/acpi/interrupts/gpe2A
       0   invalid
/sys/firmware/acpi/interrupts/gpe37
       0   invalid
/sys/firmware/acpi/interrupts/gpe2B
       0   invalid
/sys/firmware/acpi/interrupts/gpe38
       0   invalid
/sys/firmware/acpi/interrupts/gpe2C
       0   invalid
/sys/firmware/acpi/interrupts/gpe39
       0   invalid
/sys/firmware/acpi/interrupts/gpe2D
       0   invalid
/sys/firmware/acpi/interrupts/gpe2E
       0   invalid
/sys/firmware/acpi/interrupts/gpe2F
       0   invalid
/sys/firmware/acpi/interrupts/gpe3A
       0   invalid
/sys/firmware/acpi/interrupts/gpe3B
       0   invalid
/sys/firmware/acpi/interrupts/gpe3C
       0   invalid
/sys/firmware/acpi/interrupts/gpe3D
       0   invalid
/sys/firmware/acpi/interrupts/gpe3E
       0   invalid
/sys/firmware/acpi/interrupts/gpe3F
       0   invalid
/sys/firmware/acpi/interrupts/sci_not
       0
/sys/firmware/acpi/interrupts/ff_pmtimer
       0   invalid
/sys/firmware/acpi/interrupts/ff_rt_clk
       0   disabled
/sys/firmware/acpi/interrupts/gpe_all
       0
/sys/firmware/acpi/interrupts/ff_gbl_lock
       0   enabled
/sys/firmware/acpi/interrupts/ff_pwr_btn
       0   enabled
/sys/firmware/acpi/interrupts/ff_slp_btn
       0   invalid


>
> Also please send the output of "ls -l /sys/devices/system/cpu/cpu*" with the
> processor driver present.

sca05-0a818ce5:~/g5_acpi_driver # ls -l /sys/devices/system/cpu/cpu*
/sys/devices/system/cpu/cpu0:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:00
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu1:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:01
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu10:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0a
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu100:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:64
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu101:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:65
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu102:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:66
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu103:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:67
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu104:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:68
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu105:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:69
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu106:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6a
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu107:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6b
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu108:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6c
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu109:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6d
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu11:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0b
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu110:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6e
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu111:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:6f
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu112:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:70
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu113:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:71
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu114:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:72
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu115:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:73
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu116:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:74
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu117:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:75
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu118:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:76
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu119:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:77
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu12:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0c
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu120:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:78
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu121:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:79
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu122:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7a
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu123:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7b
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu124:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7c
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu125:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7d
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu126:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7e
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu127:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:7f
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu13:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0d
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu14:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0e
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu15:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:0f
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu16:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:10
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu17:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:11
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu18:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:12
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu19:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:13
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu2:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:02
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu20:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:14
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu21:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:15
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu22:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:16
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu23:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:17
lrwxrwxrwx 1 root root    0 May 30 20:09 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu24:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:18
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu25:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:19
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu26:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1a
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu27:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1b
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu28:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1c
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu29:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1d
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu3:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:03
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu30:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1e
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu31:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:1f
lrwxrwxrwx 1 root root    0 May 30 20:09 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu32:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:20
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu33:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:21
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu34:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:22
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu35:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:23
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu36:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:24
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu37:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:25
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu38:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:26
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu39:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:27
lrwxrwxrwx 1 root root    0 May 30 20:09 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu4:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:04
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu40:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:28
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu41:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:29
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu42:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2a
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu43:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2b
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu44:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2c
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu45:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2d
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu46:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2e
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu47:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:2f
lrwxrwxrwx 1 root root    0 May 30 20:09 node5 -> ../../node/node5
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu48:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:30
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu49:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:31
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu5:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:05
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu50:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:32
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu51:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:33
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu52:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:34
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu53:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:35
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu54:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:36
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu55:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:37
lrwxrwxrwx 1 root root    0 May 30 20:09 node6 -> ../../node/node6
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu56:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:38
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu57:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:39
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu58:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3a
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu59:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3b
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu6:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:06
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu60:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3c
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu61:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3d
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu62:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3e
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu63:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:3f
lrwxrwxrwx 1 root root    0 May 30 20:09 node7 -> ../../node/node7
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu64:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:40
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu65:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:41
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu66:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:42
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu67:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:43
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu68:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:44
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu69:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:45
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu7:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:07
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu70:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:46
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu71:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:47
lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu72:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:48
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu73:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:49
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu74:
total 0
drwxr-xr-x 6 root root    0 May 30 20:09 cache
drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
-r-------- 1 root root 4096 May 30 20:09 crash_notes
-r-------- 1 root root 4096 May 30 20:09 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4a
lrwxrwxrwx 1 root root    0 May 30 20:09 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:09 online
drwxr-xr-x 2 root root    0 May 30 20:09 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:09 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu75:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4b
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu76:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4c
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu77:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4d
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu78:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4e
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu79:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:4f
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu8:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:08
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu80:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:50
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu81:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:51
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu82:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:52
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu83:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:53
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu84:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:54
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu85:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:55
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu86:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:56
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu87:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:57
lrwxrwxrwx 1 root root    0 May 30 20:10 node2 -> ../../node/node2
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu88:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:58
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu89:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:59
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu9:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:09
lrwxrwxrwx 1 root root    0 May 30 20:10 node1 -> ../../node/node1
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu90:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5a
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu91:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5b
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu92:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5c
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu93:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5d
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu94:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5e
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu95:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:5f
lrwxrwxrwx 1 root root    0 May 30 20:10 node3 -> ../../node/node3
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu96:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:60
lrwxrwxrwx 1 root root    0 May 30 20:10 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu97:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:61
lrwxrwxrwx 1 root root    0 May 30 20:10 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu98:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:62
lrwxrwxrwx 1 root root    0 May 30 20:10 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpu99:
total 0
drwxr-xr-x 6 root root    0 May 30 20:10 cache
drwxr-xr-x 5 root root    0 May 30 20:10 cpuidle
-r-------- 1 root root 4096 May 30 20:10 crash_notes
-r-------- 1 root root 4096 May 30 20:10 crash_notes_size
lrwxrwxrwx 1 root root    0 May 30 20:10 driver ->
../../../../bus/cpu/drivers/processor
lrwxrwxrwx 1 root root    0 May 30 20:10 firmware_node ->
../../../LNXSYSTM:00/LNXCPU:63
lrwxrwxrwx 1 root root    0 May 30 20:10 node4 -> ../../node/node4
-rw-r--r-- 1 root root 4096 May 30 20:10 online
drwxr-xr-x 2 root root    0 May 30 20:10 power
lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
drwxr-xr-x 2 root root    0 May 30 20:10 thermal_throttle
drwxr-xr-x 2 root root    0 May 30 20:10 topology
-rw-r--r-- 1 root root 4096 May 30 20:03 uevent

/sys/devices/system/cpu/cpuidle:
total 0
-r--r--r-- 1 root root 4096 May 30 20:10 current_driver
-r--r--r-- 1 root root 4096 May 30 20:10 current_governor_ro
