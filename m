Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaCGWwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:52:36 -0500
Received: from mail-pb0-f67.google.com ([209.85.160.67]:62030 "EHLO
	mail-pb0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCGWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:52:34 -0500
Date: Fri, 7 Mar 2014 14:52:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Manuel Krause <manuelkrause@netscape.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: 3.13.?: Strange / dangerous fan policy...
Message-ID: <20140307225230.GA31135@roeck-us.net>
References: <531A1EEE.9090101@netscape.net>
 <20140307205506.GA6870@roeck-us.net>
 <531A426D.6080100@netscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531A426D.6080100@netscape.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:04:29PM +0100, Manuel Krause wrote:
> On 2014-03-07 21:55, Guenter Roeck wrote:
> >On Fri, Mar 07, 2014 at 08:33:02PM +0100, Manuel Krause wrote:
> >>Please have a short look at the following BUG report + the comments
> >>-- this message here is a kind of FWD-ing it:
> >>https://bugs.archlinux.org/task/39005
> >>
> >>I came late to test kernel 3.13 with the .5 one, as it was the time
> >>that the related -CK/BFS patch became available.
> >>
> >>I'm not using Archlinux, but openSUSE, and my problems are quite the
> >>same. Especially these with smelling melting plastics.
> >>
> >>My own reports went to Con Kolivas' Blog first:
> >>"I get weird temperatures and abrupt 100% fan actions with vanilla
> >>3.13.5 with this CK and most recent BFQ at my HP Notebook.
> >>In gkrellm the highest T had been @74°C, so far (3.12.13), and is
> >>now growing to 94°C. Then, the fan goes to 100% for 10~30secs
> >>cooling it to approx. 82°C.
> >>That is not good, if I compare 74 to 94 °C.
> >>Have I missed a .CONFIG option for 3.13, especially?"
> >>
> >>I'd get the same without (Con's && BFQ's) patches.
> >>
> >>Machine:           HP Notebook with Core2Duo CPU (Penryn)
> >>Distro:            openSUSE 13.1, 64bit, continuously updated
> >>Desktop:           KDE 4.12.3
> >>MESA & drm & Xorg: most recent ones from:
> >>http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_13.1/x86_64/
> >>
> >>Current kernel:    3.13.6 vanilla from openSUSE repos, with
> >>                    -ck1 and BFQ patches
> >>Same behaviour:    without these patches
> >>
> >>Last good kernel:  3.12.13 vanilla + CK2 + BFQ
> >>
> >
> >Can you add more information about your fan control policy ?
> >Do you rely on the hardware for automatic fan speed control,
> >or do you run the fancontrol script ?
> >
> >What is the output from the 'sensors' command ?
> >
> >Thanks,
> >Guenter
> >
> 
> Hi, and thanks for the quick response!
> No special fancy "fan control policy". 'fancontrol' isn't up or
> running.
> Vanilla kernels 3.11.* and 3.12.* had been working on here without
> any extra work.
> --
> # sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:        +71.0°C  (crit = +256.0°C)
> temp2:        +69.0°C  (crit = +110.0°C)
> temp3:        +52.0°C  (crit = +105.0°C)
> temp4:        +25.0°C  (crit = +110.0°C)
> temp5:        +58.0°C  (crit = +110.0°C)
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> Core 0:       +62.0°C  (high = +105.0°C, crit = +105.0°C)
> Core 1:       +60.0°C  (high = +105.0°C, crit = +105.0°C)
> --
> My notebook (HP/Compaq 6730b) does not have a seperate fan sensor.
> This is with 3.12.13 with my normal workload.
> 
> Please, trust my above mentionned values of 94 °C vs. 74°C as I
> don't like to boot 3.13.6 anymore, to avoid harm to the notebook's
> casing.
> 
Understood. Unfortunately, we'll need to get information
from the new kernel to be able to track down the problem.

> But I'd do to test any improvement-patch.
> 
So far I have no idea what is going on. I don't see anything in the
drivers providing above data that would explain the behavior,
but I might be missing something.

Of course, if output is different in 3.13, that would be important
to know. Maybe someone else can post related information for both
kernel versions on an affected system.

Guenter
