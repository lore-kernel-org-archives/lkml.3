Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3GTKrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 06:47:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55729 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab3GTKrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 06:47:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, systemd-devel@lists.freedesktop.org
Subject: udev: New default rule for autoloading kernel modules matching CPU modalias
Date: Sat, 20 Jul 2013 12:56:54 +0200
Message-ID: <1623844.aKWlCHQqy1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

After a recent change present in 3.11-rc1 there is a driver, called processor,
that can be bound to the CPU devices whose sysfs directories are located under
/sys/devices/system/cpu/.  A side effect of this is that, after the driver has
been bound to those devices, the kernel adds DRIVER=processor to ENV for CPU
uevents and they don't match the default rule for autoloading modules matching
MODALIAS:

DRIVER!="?*", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"

any more.  However, there are some modules whose module aliases match specific
CPU features through the modalias string and those modules should be loaded
automatically if a compatible CPU is present.  Yet, with the processor driver
bound to the CPU devices the above rule is not sufficient for that, so we need
a new default udev rule allowing those modules to be autoloaded even if the
CPU devices have drivers.

On my test systems I added the following rule for that:

ACTION="add", SUBSYSTEM=="cpu", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"

in a separate file, but I'm not a udev expert, so I guess it may be done in a
better way.

Can you please consider adding such a rule to the default set of udev rules?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
