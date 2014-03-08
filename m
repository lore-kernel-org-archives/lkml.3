Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaCHMVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:21:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57160 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751099AbaCHMVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:21:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jean Delvare <jdelvare@suse.de>, Manuel Krause <manuelkrause@netscape.net>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [lm-sensors] 3.13.?: Strange / dangerous fan policy...
Date: Sat, 08 Mar 2014 13:36:58 +0100
Message-ID: <1423969.TQuRFJ3izd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140308120831.328e0179@endymion.delvare>
References: <531A1EEE.9090101@netscape.net> <20140307225230.GA31135@roeck-us.net> <20140308120831.328e0179@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 08, 2014 12:08:31 PM Jean Delvare wrote:
> On Fri, 7 Mar 2014 14:52:30 -0800, Guenter Roeck wrote:
> > On Fri, Mar 07, 2014 at 11:04:29PM +0100, Manuel Krause wrote:
> > > Hi, and thanks for the quick response!
> > > No special fancy "fan control policy". 'fancontrol' isn't up or
> > > running.
> > > Vanilla kernels 3.11.* and 3.12.* had been working on here without
> > > any extra work.
> > > --
> > > # sensors
> > > acpitz-virtual-0
> > > Adapter: Virtual device
> > > temp1:        +71.0°C  (crit = +256.0°C)
> > > temp2:        +69.0°C  (crit = +110.0°C)
> > > temp3:        +52.0°C  (crit = +105.0°C)
> > > temp4:        +25.0°C  (crit = +110.0°C)
> > > temp5:        +58.0°C  (crit = +110.0°C)
> > > 
> > > coretemp-isa-0000
> > > Adapter: ISA adapter
> > > Core 0:       +62.0°C  (high = +105.0°C, crit = +105.0°C)
> > > Core 1:       +60.0°C  (high = +105.0°C, crit = +105.0°C)
> > > --
> > > My notebook (HP/Compaq 6730b) does not have a seperate fan sensor.
> > > This is with 3.12.13 with my normal workload.
> > > 
> > > Please, trust my above mentionned values of 94 °C vs. 74°C as I
> > > don't like to boot 3.13.6 anymore, to avoid harm to the notebook's
> > > casing.
> > 
> > Understood. Unfortunately, we'll need to get information
> > from the new kernel to be able to track down the problem.
> 
> Indeed. Not only the run-time temperatures, but also the high and crit
> limits.
> 
> > > But I'd do to test any improvement-patch.
> > 
> > So far I have no idea what is going on. I don't see anything in the
> > drivers providing above data that would explain the behavior,
> > but I might be missing something.
> 
> Looks like a regression in the acpi subsystem or in power management,
> not hwmon. Hwmon is merely reporting the temperatures, it's not
> responsible for the actual temperatures.
> 
> A bisection would certainly help, but of course that would require
> booting to a bad kernel half of the time, which I understand Manual
> wouldn't enjoy.
> 
> The only two components which I think can reach such high temperatures
> in a laptop are the CPU and the GPU. I suppose that the "94 °C vs.
> 74°C" refers to acpitz's temp1? If the the temperatures reported by
> coretemp remain the same, then I can only suppose that temp1 is the GPU
> temperature. Please tell us which GPU is in this laptop, and which
> driver you're using.

Also it would be good to know which cpufreq and cpuidle drivers are in use
and whether or not 3.14-rc5 has the problem.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
