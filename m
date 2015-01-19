Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbbASNWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:22:00 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:44089 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbASNV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:21:59 -0500
Date: Mon, 19 Jan 2015 14:21:55 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <13866742.20150119142155@eikelenboom.it>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: if power button pressed 1x it creates the same ACPI event twice
In-Reply-To: <577867575.20150119140934@eikelenboom.it>
References: <618666178.20150113173510@eikelenboom.it> <1202643605.20150113174724@eikelenboom.it> <577867575.20150119140934@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, January 19, 2015, 2:09:34 PM, you wrote:

> Hello Sander,

> Tuesday, January 13, 2015, 5:47:24 PM, you wrote:

>> Tuesday, January 13, 2015, 5:35:10 PM, you wrote:

>>> Hi Rafael / Len,

>>> When i press the power-button on my intel NUC, i get twp ACPI power-events shortly 
>>> after one another (within a second), instead of just one. 

>>> It doesn't matter if i have the old /proc/acpi interface enabled or disabled in the kernel config.

>>> I have tested a few older kernels lingering around on the box and 3.14 already 
>>> has this problem. 3.2 (from the debian repo) doesn't have the problem, it only 
>>> fires one event.

>>> I did find another report:
>>>     Re: lenovo ultrabay docking station: if power button pressed 1x it creates 2x the same ACPI event
>>>     http://www.spinics.net/lists/linux-acpi/msg54723.html
>>> But that hasn't come to a conclusion ...


>>> Unfortunately 3.2 - 3.19-rc4 is a bit of a largish bisect window, so that's 
>>> unfeasible :-)

>>> I compiled in apci debug support and tried:
>>>  echo "0x00080000" > /sys/module/acpi/parameters/debug_layer
>>>  echo "0xffffffff" > /sys/module/acpi/parameters/debug_level

>>> But i don't get any extra output in dmesg ?

>>> Do you have any ideas for a debug patch or better values to figure out what is going on ?

>>> --
>>> Sander

>> Hmm is it normal that it registers in this way (twice) ?

>> [    5.817980] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
>> [    5.837907] ACPI: Power Button [PWRB]
>> [    5.847540] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    5.866915] ACPI: Power Button [PWRF]

>> --
>> Sander

> Hi Rafael / Len,

> Got some more time to test:

> - It's indeed giving one event for both registered power buttons (which in reality 
>   are just one hardware button) printing acpid's "%e" revealed that:
>   1421672289-161192235 | button/power PBTN 00000080 00000000
>   1421672289-279647745 | button/power LNXPWRBN:00 00000080 00000004

> So i tested on another box (amd instead of intel), and that also registers 2 
> power buttons:

> # dmesg | grep -i button
> [   13.435060] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [   13.435294] ACPI: Power Button [PWRB]
> [   13.435495] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [   13.435683] ACPI: Power Button [PWRF]
>  
> So the question is .. should both register and should scripts adjust to pick up just one of them ?
> Or can, as a more general solution, just one be ignored when registering ?

> --
> Sander

Whoops sorry for the fragmentation of the report ... but just thought the output 
under kernel 3.2.0 could be handy as well .. as that only fires one event:

[    4.003753] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    4.003838] ACPI: Power Button [PWRB]
[    4.003977] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.005530] ACPI: Power Button [PWRF]

It registers also two ..
But when the power button is pressed only fires this one:

1421673524-817561070 | button/power PBTN 00000080 00000000

--
Sander

