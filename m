Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaJ0Pb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:31:28 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:59281 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaJ0Pb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1414419657.30379.51.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CAMuHMdWw+rX-r2uVN0ZL-GFirOkCn7+Gh7BVd3JvyXXS_pcdVw@mail.gmail.com>
	<1414419657.30379.51.camel@hadess.net>
Date: Mon, 27 Oct 2014 16:31:24 +0100
X-Google-Sender-Auth: w5asCUoYRyf3DR-plHwLLdiEh3o
Message-ID: <CAMuHMdWG=ayxEAno2VYMK=fvf8Brx4rFMc75WOSh2PPLntaa8w@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bastien,

On Mon, Oct 27, 2014 at 3:20 PM, Bastien Nocera <hadess@hadess.net> wrote:
> On Tue, 2014-10-21 at 20:24 +0200, Geert Uytterhoeven wrote:
>> On Tue, Oct 21, 2014 at 7:14 PM, Bastien Nocera <hadess@hadess.net> wrote:
>> >> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
>> >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
>> >> documentation'
>> >>
>> >> Can you expand more on the rational for the need here? Is this for UI
>> >> for power debugging, or something else?
>> >
>> > No, it would be used for automating backups, or implementing
>> > suspend->hibernation transitions. For example, right before the machine
>> > suspends, I would schedule it to wake up in a hour. If I get woken up by
>> > the rtc alarm (and not by the user through a lid open), I might:
>> > - check that I'm plugged into the AC, it's night, and in the vicinity of
>> > the server that handles my backups and so backup the system.
>> > - check whether the battery is low, and hibernate the machine (if it
>> > supports it, obviously).
>>
>> Isn't this already available through /sys/kernel/debug/wakeup_sources
>> and/or the various power/wake* files in sysfs?
>
> That might very well be, but /sys/kernel/debug/wakeup_sources really
> isn't much of a user-space API. Where's the documentation for the
> various power/wake* files?

The debugfs entry is indeed not documented.
Documentation for the others is just a git grep away:

 $ git grep power/wake -- Documentation/
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup
Documentation/ABI/testing/sysfs-devices-power:          The
/sys/devices/.../power/wakeup attribute allows the user
Documentation/ABI/testing/sysfs-devices-power:          have one of
the following two values for the sysfs power/wakeup
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_count
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_active_count
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_abort_count
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_expire_count
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_active
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_total_time_ms
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_max_time_ms
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_last_time_ms
Documentation/ABI/testing/sysfs-devices-power:What:
/sys/devices/.../power/wakeup_prevent_sleep_time_ms
Documentation/ABI/testing/sysfs-power:What:             /sys/power/wakeup_count
Documentation/ABI/testing/sysfs-power:          The
/sys/power/wakeup_count file allows user space to put the
Documentation/ABI/testing/sysfs-power:What:             /sys/power/wake_lock
Documentation/ABI/testing/sysfs-power:          The
/sys/power/wake_lock file allows user space to create
Documentation/ABI/testing/sysfs-power:
/sys/power/wakeup_count file block or return false).  When a
Documentation/ABI/testing/sysfs-power:          string without white
space is written to /sys/power/wake_lock,
Documentation/ABI/testing/sysfs-power:          If a string written to
/sys/power/wake_lock contains white
Documentation/ABI/testing/sysfs-power:What:             /sys/power/wake_unlock
Documentation/ABI/testing/sysfs-power:          The
/sys/power/wake_unlock file allows user space to deactivate
Documentation/ABI/testing/sysfs-power:          wakeup sources created
with the help of /sys/power/wake_lock.
Documentation/ABI/testing/sysfs-power:          When a string is
written to /sys/power/wake_unlock, it will be
Documentation/ABI/testing/sysfs-power:          wakeup sources created
with the help of /sys/power/wake_lock
Documentation/power/devices.txt:        using the relevant
/sys/devices/.../power/wakeup file (for Ethernet
Documentation/power/devices.txt:/sys/devices/.../power/wakeup files
Documentation/power/devices.txt:"power/wakeup" file.  User space can
write the strings "enabled" or "disabled"
Documentation/power/devices.txt:The "power/wakeup" file is supposed to
contain the "disabled" string initially
Documentation/power/devices.txt:exists and the corresponding
"power/wakeup" file contains the string "enabled".
Documentation/usb/power-management.txt: power/wakeup

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
