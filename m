Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaENGoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:44:30 -0400
Received: from mout.gmx.net ([212.227.17.21]:55925 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaENGo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:44:29 -0400
Date: Wed, 14 May 2014 08:44:14 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, andreas.werner@men.de
Subject: Re: Question: hwmon: Adding addtitional sysfs entries
Message-ID: <20140514064414.GA3592@thinkpad.fritz.box>
References: <20140510132238.GA28364@awedesk.fritz.box>
 <536E1C4D.9030206@roeck-us.net>
 <20140510160217.GA775@awedesk.fritz.box>
 <536E4698.5030106@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <536E4698.5030106@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:dcGNvrndjzcTgCWNrb6qS2mQzQhIAfjv5tG8Cwvw+QKlAMeXF7Y
 a8/jgaLLRacKHeREqYzi0uAo2Z+ZZUU5ez2YxTYdGQITyhX6ae1ffOyhQaDnXOW4yB0GntD
 XBWnFxXX/iydYXjFBXpC/s11zdQlhCTCUGwMbEfRni8W8jVM3GEBf1v0e2obQEjAB5/z7Ey
 OqxsWBxmzq3B7LP9ANLjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 08:32:40AM -0700, Guenter Roeck wrote:
> On 05/10/2014 09:02 AM, Andreas Werner wrote:
> >On Sat, May 10, 2014 at 05:32:13AM -0700, Guenter Roeck wrote:
> >>On 05/10/2014 06:22 AM, Andreas Werner wrote:
> >>>Hi,
> >>>i am currently working on an implemenation of my Board Management Controller (BMC).
> >>>
> >>>This Controller is a MCR assembled on almost all of our Compact PCI or Compact PCI Serial
> >>>Cards as well as on some other CPU Boards.
> >>>
> >>>The BMC includes LED´s, Watchdog, Voltage Monitoring and some other features.
> >>>I have already implemented an MFD driver, LED and Watchdog driver.
> >>>
> >>>Currently i am working on the hwmon implemenation. This includes for the first step the
> >>>voltage monitoring.
> >>>
> >>>The BMC has some other feature which are not supported by any of the subsystem.
> >>>  - Errorcounter (Board status)
> >>>  - Power Failure status
> >>>  - Operating ours
> >>
> >>Guess you mean hours here.
> >
> >Yes sorry my mistake.
> >
> >>
> >>>  - Do software reset, do cold reset
> >>>  - Set power modes
> >>>  - Backplate Geographical Address
> >>>
> >>>These are all informations related to the Board where the BMC is assembled to.
> >>>I think all those features could be part of the hwmon implementation.
> >>>
> >>Why ?
> >
> >As all of the settings are CPU board related i thought it will be an good idea
> >to put as much settings as possible to a group to one subsystem.
> >This would be easier for the User Application.
> >
> Bad argument, even for the users. A user would not normally expect to find
> the above information in unrelated subsystems such as hwmon. Keep in mind that
> the Linux kernel is supposed to be useful for more than the application developers
> in your company, and think about it - assume you would have to implement an
> application which runs on more than one hardware, and attributes like the above
> would be spread throughout the system. It would be all but impossible to write
> generic applications, so you would want to avoid adding anything non-standard
> as much as you can. And if you have to implement something non-standard, at least
> implement it where people at least have a chance to find it.
>
Ok, you are right :-)
 
> >>
> >>>Is it possible to add "custom" sysfs entries in my hwmon driver to support all these features?
> >>>Does lm-sensor ingore those custom features or is it a problem for lm-sensors?
> >>>
> >>>What is the normal way to add those features?
> >>>
> >>
> >>The hwmon subsystem isn't really the correct location for this functionality.
> >>Power management should be done with a regulator driver (possibly power).
> >>The other attributes and functionality would better fit into the mfd core
> >>driver.
> >>
> >
> >MFD Core sounds good. That is also perfect for the User App.
> >
> >>You might want to tie the reset functions into the system reset functionality.
> >
> >I do not understand this. Is there another subsystem or something like that
> >were I can put the Reset stuff to?
> >
> Assuming you are talking about system reset, there is a function named machine_restart()
> to accomplish that. This is architecture and, in many cases, machine specific functionality.
> For example, many arm architectures have a different means to reset the system, and there
> is a separate function pointer named arm_pm_restart to tie into that functionality.
> 
> Many restart functions are implemented in the drivers/power/reset directory, which may be
> a good location for yours.
> 
Just for explanation and to avoid missunderstanding. The reset functionality of the BMC
is to send a I2C command from the Host to the BMC, and the BMC does the reset or power down.

There is also a functionality where you can send a command the Controller and he will press
the "power button" which cause an ACPI event to shutdown the PC if configured.

Thanks for the /drivers/power informations there is really nice code in there where I can
pick up some stuff to implement functions like that.

> >
> >I guess the hwmon subsys is the right place for the voltage monitoring (3,3V, 5V etc) isn´t it?
> >
> Yes, that is what it is for.

Thanks, works fine. Nice integration in lm_sensors thats what I love in Linux :-)
> 
> Guenter
> 
Regards
Andy
