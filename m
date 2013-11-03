Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3KCQEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 11:04:14 -0500
Received: from mail-ea0-f194.google.com ([209.85.215.194]:42577 "EHLO
	mail-ea0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3KCQEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 11:04:12 -0500
X-Greylist: delayed 3388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Nov 2013 11:04:12 EST
From: andreas.thalhammer@linux.com
Reply-To: andreas.thalhammer@linux.com
To: linux-kernel@vger.kernel.org
Subject: A Desktop Linux idea: modulized open hardware database for the linux kernel config
Date: Sun, 3 Nov 2013 15:53:26 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.3-gentoo-6.0; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201311031553.26488.andreas.thalhammer@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML!

I am a Linux Desktop user since around 2001. Doing the math, that’s more than 
a decade!

Having watched http://www.youtube.com/watch?v=jjRAKuis7T8 (LinuxCon 2013, Dirk 
Hohndel and Linus Torvalds on stage) I decided to share an idea I had to make 
kernel building easier for computer end-users:

How aboud a free and open hardware database for configuring Linux?

My idea would make a very simple to get kernel configuration for a modulized 
hardware and feature base. It should be some kind of open for everybody 
database in which everyone may participate.

(This would off course only be of use for power users or developers. Regular 
users will use stock kernels from their Linux distribution anyway. BTW, I use 
Gentoo Linux.)

An example:
My computer is a PC. The motherboard is an MSI 890FXA-GD70, it has an AMD 
Phenom II X6 1090T in the CPU slot. So this setup would be the basic entry to 
look for, which will provide a kernel configurtion for this specific hardware. 
For example, the module for the Fintek F71889ED Super IO Sensor has to be 
selected (CONFIG_SENSORS_F71882FG) as well as CONFIG_SENSORS_K10TEMP for the 
CPU.

I  know lm_sensors has a tools for that already: sensors-detect. But not 
everything is covered there, is there?

Then I would also combine this config with a config module for my graphics 
card. It is a Radeon HD 6770, so readonkms has to be selected properly. Some 
kernel parameters may also be wise, such as video=radeondrmfb, radeon.aspm=1 
and radeon.dpm=1.

It should also be possible to combine this config with a config module for my 
monitor. This will show that the resolution of this monitor is 1680x1050. 
Unfortunately this resultution is not part of the VESA BIOS, so the kernel 
command-line parameter video=radeondrmfb will be expanded by 1680x1050-32@60.

Some basic profiles may define how the PC will be used: i.e. as a file server, 
as a Desktop conputer or as a gaming computer. A "cutting edge with all the 
new features" profile may select everything that is usable for this computer.

Every ISA/EISA/VLB/PCI/AGP/PCIe expansion card can and will add some config 
settings to the big kernel configuration. I.e. if you had a DVB-TV card or 
whatever.

A basic "All USB-end-user-devices" config module for all possible USB devices 
may select everything except those self-made stuff, like a thermal probe. On 
the other hand, specific stuff should be allowed too. I.e. the Digitus 
Cardreader All-in-one, USB 3.0 (DA-70330) – is a specific reader module 
required (CONFIG_USB_STORAGE_*)?

In the end there would be a hardware database, maybe combined with a wiki, 
that includes developer information like hardware addresses and such as well 
as user reports and kernel configuration modules for that hardware.

Jumping to a newer kernel will automatically set the new/changed 
CONFIG_SOMETHING for the selected profile.

This would also be handy for Laptops and very narrow configured hardware such 
as Apple computers (my Power Mac G4 for example).

A tool for this could go into the kernel sources. It would detect the hardware 
present in the system using everything that is available (e.g. lspci) and show 
a configuration menu (make config-alike) that will enable the user to select 
or deselect specific hardware config modules and profiles (i.e. "file 
server").

Compiling a new kernel will then not result in searching the whole kernel 
config for new or changed options like it is now (just recently I had to 
change video=radeonfb to video=radeonkmsfb in my GRUB config).

For kernel developers this could also be a very useful tool, because users can 
point to the specific hardware that makes troubles on Linux. And, like it is 
in a community, developers may be able to reach users willing to participate 
in testing new patches for fixing these troubles…

This is just an idea. Now it’s out there – do with it whatever you like. The 
idea is hereby released under the GPL-2 :-)
