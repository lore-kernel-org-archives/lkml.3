Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3ECQzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:55:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:56232 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762994Ab3ECQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:55:40 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+DJyUN8WKDa+wc6qIez//nx+NUMUxisgG9H9I5mt
	fVvsWjRQRFK6kP
Message-ID: <5183EC09.9080208@gmx.de>
Date: Fri, 03 May 2013 18:55:37 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following file doesn't exists at my Gentoo Linux
/sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
in 3.9.0 if I activate CONFIG_X86_INTEL_PSTATE=y 

That means, that a command like

$> echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load

in /etc/rc.local is now no longer working.
A high fan +  high temperature are the result, even if just the BOINC client
is run with low prio (nice 19) in the back ground.

Manually loading the missing module won't work too :

$> modprobe acpi_cpufreq
modprobe: ERROR: could not insert 'acpi_cpufreq': Device or resource busy

Is the behaviour a bug or a feature ?
In the later case: How can I achieve the previous behaviour back ?

This issue might affect the RH EL kernel too [1] where I observed a similar behaviour.


[1] http://elrepo.org/bugs/view.php?id=379

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
