Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab3E3On3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:43:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56313 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932777Ab3E3OnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:43:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: System slow down from udev
Date: Thu, 30 May 2013 16:45:35 +0200
Message-ID: <5738208.7rKb57pu5j@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3463581.AQ3EkyvJ7g@vostro.rjw.lan>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <CAE9FiQWroCPOitz-k0h5Rm2+qqBitAySE7m6fqaKmzA+xdJn1w@mail.gmail.com> <3463581.AQ3EkyvJ7g@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 04:34:51 PM Rafael J. Wysocki wrote:
> [Adding CC to Toshi Kani just in case he has an idea.]
> 
> On Wednesday, May 29, 2013 06:55:33 PM Yinghai Lu wrote:
> > On Wed, May 29, 2013 at 4:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Wednesday, May 29, 2013 03:49:38 PM Yinghai Lu wrote:
> > >> On Wed, May 29, 2013 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > On Wednesday, May 29, 2013 01:13:46 PM Yinghai Lu wrote:
> > >> >> On Wed, May 29, 2013 at 4:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> >> > On your systems the processor driver is built-in.  Any chance to build it as
> > >> >> > a module and see if that helps?
> > >> >>
> > >> >> it CONFIG_ACPI_PROCESSOR it not set in the config
> > >> >> the boot get to normal speed.
> > >> >
> > >> > Well, if it is not set at all, there won't be problems with it. :-)
> > >> >
> > >> > I've tested my linux-next branch on OpenSUSE 11.3 both with the processor
> > >> > driver built in and modular and I'm not able to reproduce the issue you're
> > >> > seeing.
> > >> >
> > >> > Moreover, I'm not sure if user space is involved here at all, because the
> > >> > problem triggers for you when all of the relevant kernel code is non-modular.
> > >> >
> > >> > With the processor driver enabled, when the slowdown happens, are the systems
> > >> > usable enough to get some debug info out of them?
> > >>
> > >> please check the bootchart data.
> > >>
> > >> looks like it take 200s if no acpi_processor ...
> > >> otherwise will take 800s or more.
> > >
> > > Well, something's fishy for sure.
> > >
> > > To my eyes it looks like we're getting lots of notifications related to the
> > > processor driver and that generates a lot of workqueue load.
> > >
> > > Can you please get /proc/interrupts from both cases and the output of
> > > "find /sys/firmware/acpi/interrupts/ -print -exec cat {} \;"?
> 
> Thanks for the info!
> 
> > sca05-0a818ce5:~/g5_acpi_driver # find /sys/firmware/acpi/interrupts/
> > -print -exec cat {} \;
> > /sys/firmware/acpi/interrupts/
> > cat: /sys/firmware/acpi/interrupts/: Is a directory
> > /sys/firmware/acpi/interrupts/sci
> >        0
> > /sys/firmware/acpi/interrupts/error
> >        0
> > /sys/firmware/acpi/interrupts/gpe00
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe01
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe02
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe03
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe04
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe05
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe06
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe07
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe08
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe09
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe10
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe11
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe12
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe13
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe14
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe15
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe16
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe0A
> >        0   enabled
> > /sys/firmware/acpi/interrupts/gpe17
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe0B
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe18
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe0C
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe19
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe0D
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe0E
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe20
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe0F
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe21
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe22
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe23
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe24
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe25
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe26
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1A
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe27
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1B
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe28
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1C
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe29
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1D
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1E
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe30
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe1F
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe31
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe32
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe33
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe34
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe35
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe36
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2A
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe37
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2B
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe38
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2C
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe39
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2D
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2E
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe2F
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3A
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3B
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3C
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3D
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3E
> >        0   invalid
> > /sys/firmware/acpi/interrupts/gpe3F
> >        0   invalid
> > /sys/firmware/acpi/interrupts/sci_not
> >        0
> > /sys/firmware/acpi/interrupts/ff_pmtimer
> >        0   invalid
> > /sys/firmware/acpi/interrupts/ff_rt_clk
> >        0   disabled
> > /sys/firmware/acpi/interrupts/gpe_all
> >        0
> > /sys/firmware/acpi/interrupts/ff_gbl_lock
> >        0   enabled
> > /sys/firmware/acpi/interrupts/ff_pwr_btn
> >        0   enabled
> > /sys/firmware/acpi/interrupts/ff_slp_btn
> >        0   invalid
> 
> OK, no GPEs.  Interesting.
> 
> > > Also please send the output of "ls -l /sys/devices/system/cpu/cpu*" with the
> > > processor driver present.
> > 
> > sca05-0a818ce5:~/g5_acpi_driver # ls -l /sys/devices/system/cpu/cpu*
> > /sys/devices/system/cpu/cpu0:
> > total 0
> > drwxr-xr-x 6 root root    0 May 30 20:09 cache
> > drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
> > -r-------- 1 root root 4096 May 30 20:09 crash_notes
> > -r-------- 1 root root 4096 May 30 20:09 crash_notes_size
> > lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
> > ../../../../bus/cpu/drivers/processor
> > lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
> > ../../../LNXSYSTM:00/LNXCPU:00
> > lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
> > drwxr-xr-x 2 root root    0 May 30 20:09 power
> > lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
> > drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
> > drwxr-xr-x 2 root root    0 May 30 20:09 topology
> > -rw-r--r-- 1 root root 4096 May 30 20:03 uevent
> > 
> > /sys/devices/system/cpu/cpu1:
> > total 0
> > drwxr-xr-x 6 root root    0 May 30 20:09 cache
> > drwxr-xr-x 5 root root    0 May 30 20:09 cpuidle
> > -r-------- 1 root root 4096 May 30 20:09 crash_notes
> > -r-------- 1 root root 4096 May 30 20:09 crash_notes_size
> > lrwxrwxrwx 1 root root    0 May 30 20:09 driver ->
> > ../../../../bus/cpu/drivers/processor
> > lrwxrwxrwx 1 root root    0 May 30 20:09 firmware_node ->
> > ../../../LNXSYSTM:00/LNXCPU:01
> > lrwxrwxrwx 1 root root    0 May 30 20:09 node0 -> ../../node/node0
> > -rw-r--r-- 1 root root 4096 May 30 20:09 online
> > drwxr-xr-x 2 root root    0 May 30 20:09 power
> > lrwxrwxrwx 1 root root    0 May 30 20:03 subsystem -> ../../../../bus/cpu
> > drwxr-xr-x 2 root root    0 May 30 20:09 thermal_throttle
> > drwxr-xr-x 2 root root    0 May 30 20:09 topology
> > -rw-r--r-- 1 root root 4096 May 30 20:03 uevent
> 
> [Skipping a number of analogous items.]
> 
> Well, it seems to initialize correctly at least.
> 
> > /sys/devices/system/cpu/cpuidle:
> > total 0
> > -r--r--r-- 1 root root 4096 May 30 20:10 current_driver
> > -r--r--r-- 1 root root 4096 May 30 20:10 current_governor_ro
> 
> Well, this shows that my previous suspicion regarding notifications wasn't
> justified, as there are none of them, apparently.
> 
> Also the CPUs' directory structures in sysfs look correctly to me.  The
> driver binds to the devices it is supposed to bind to and acpi_bind_one()
> works as expected.  Hmm.
> 
> Let's see if thermal throttling is not going on.  Please send the output of:
> $ find /sys/devices/system/cpu/ -name core_throttle_count -print -exec cat {} \;
> $ find /sys/devices/system/cpu/ -name package_throttle_count -print -exec cat {} \;
> 
> from the affected systems.
> 
> I'll try to dig deeper locally in the meantime.

Actually, I think I know what the problem is, but I need some more time to
debug it.  Fortunately, I'm able to see some symptoms. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
