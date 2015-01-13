Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbbAMQfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:35:16 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:44952 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbAMQfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:35:14 -0500
Date: Tue, 13 Jan 2015 17:35:10 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <618666178.20150113173510@eikelenboom.it>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: if power button pressed 1x it creates the same ACPI event twice
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael / Len,

When i press the power-button on my intel NUC, i get twp ACPI power-events shortly 
after one another (within a second), instead of just one. 

It doesn't matter if i have the old /proc/acpi interface enabled or disabled in the kernel config.

I have tested a few older kernels lingering around on the box and 3.14 already 
has this problem. 3.2 (from the debian repo) doesn't have the problem, it only 
fires one event.

I did find another report:
    Re: lenovo ultrabay docking station: if power button pressed 1x it creates 2x the same ACPI event
    http://www.spinics.net/lists/linux-acpi/msg54723.html
But that hasn't come to a conclusion ...


Unfortunately 3.2 - 3.19-rc4 is a bit of a largish bisect window, so that's 
unfeasible :-)

I compiled in apci debug support and tried:
 echo "0x00080000" > /sys/module/acpi/parameters/debug_layer
 echo "0xffffffff" > /sys/module/acpi/parameters/debug_level

But i don't get any extra output in dmesg ?

Do you have any ideas for a debug patch or better values to figure out what is going on ?

--
Sander

