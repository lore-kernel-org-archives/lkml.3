Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbbAMQrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:47:33 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:45063 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbAMQrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:47:31 -0500
Date: Tue, 13 Jan 2015 17:47:24 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1202643605.20150113174724@eikelenboom.it>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: if power button pressed 1x it creates the same ACPI event twice
In-Reply-To: <618666178.20150113173510@eikelenboom.it>
References: <618666178.20150113173510@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday, January 13, 2015, 5:35:10 PM, you wrote:

> Hi Rafael / Len,

> When i press the power-button on my intel NUC, i get twp ACPI power-events shortly 
> after one another (within a second), instead of just one. 

> It doesn't matter if i have the old /proc/acpi interface enabled or disabled in the kernel config.

> I have tested a few older kernels lingering around on the box and 3.14 already 
> has this problem. 3.2 (from the debian repo) doesn't have the problem, it only 
> fires one event.

> I did find another report:
>     Re: lenovo ultrabay docking station: if power button pressed 1x it creates 2x the same ACPI event
>     http://www.spinics.net/lists/linux-acpi/msg54723.html
> But that hasn't come to a conclusion ...


> Unfortunately 3.2 - 3.19-rc4 is a bit of a largish bisect window, so that's 
> unfeasible :-)

> I compiled in apci debug support and tried:
>  echo "0x00080000" > /sys/module/acpi/parameters/debug_layer
>  echo "0xffffffff" > /sys/module/acpi/parameters/debug_level

> But i don't get any extra output in dmesg ?

> Do you have any ideas for a debug patch or better values to figure out what is going on ?

> --
> Sander

Hmm is it normal that it registers in this way (twice) ?

[    5.817980] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.837907] ACPI: Power Button [PWRB]
[    5.847540] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.866915] ACPI: Power Button [PWRF]

--
Sander

