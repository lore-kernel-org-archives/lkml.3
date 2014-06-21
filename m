Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaFUUfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:35:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaFUUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:35:08 -0400
Date: Sat, 21 Jun 2014 22:35:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.16, i915: less colors in X?
Message-ID: <20140621203506.GA4756@amd.pavel.ucw.cz>
References: <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140621202901.GA3840@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140621202901.GA3840@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-06-21 22:29:01, Pavel Machek wrote:
> Hi!
> 
> I just test-booted 3.16-rc1, and background in X looked just wrong --
> very noticeable bands on the background gradient. I thought that maybe
> it is just my eyes, but I went back to older kernel, and background is
> ok now.
> 
> I'm trying to figure out how to ask X what color depth it is using...?
> 
> This is thinkpad x60 with Debian 6.0.9.
> 
> Any ideas?

Xorg.log does not show anything too suspicious:

diff -u /var/log/Xorg.0.log{,.old} > /tmp/delme

									Pavel

--- /var/log/Xorg.0.log	2014-06-21 22:24:15.005229099 +0200
+++ /var/log/Xorg.0.log.old	2014-06-21 22:22:38.275847726 +0200
@@ -3,8 +3,8 @@
 Release Date: 2010-05-04
 X Protocol Version 11, Revision 0
 Build Operating System: Linux 3.2.0-4-amd64 i686 Debian
-Current Operating System: Linux duo 3.10.0+ #293 SMP Sun Jul 14 22:44:49 CEST 2013 i686
-Kernel command line: BOOT_IMAGE=(hd0,3)/boot/vmlinuz-3.10 root=/dev/sda3 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k
+Current Operating System: Linux duo 3.16.0-rc1+ #373 SMP Sat Jun 21 20:46:47 CEST 2014 i686
+Kernel command line: BOOT_IMAGE=(hd0,2)/l/linux-good/arch/x86/boot/bzImage root=/dev/sda3 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k
 Build Date: 17 December 2013  08:26:59PM
 xorg-server 2:1.7.7-18 (Julien Cristau <jcristau@debian.org>) 
 Current version of pixman: 0.16.4
@@ -13,7 +13,7 @@
 Markers: (--) probed, (**) from config file, (==) default setting,
 	(++) from command line, (!!) notice, (II) informational,
 	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
-(==) Log file: "/var/log/Xorg.0.log", Time: Sat Jun 21 22:23:28 2014
+(==) Log file: "/var/log/Xorg.0.log", Time: Sat Jun 21 21:04:49 2014
 (==) Using system config directory "/usr/share/X11/xorg.conf.d"
 (==) No Layout section.  Using the first Screen section.
 (==) No screen section available. Using defaults.
@@ -402,10 +402,17 @@
 (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
 (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
 (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
-(II) intel(0): EDID vendor "LEN", prod id 16384
-(II) intel(0): Printing DDC gathered Modelines:
-(II) intel(0): Modeline "1024x768"x0.0   54.16  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (40.3 kHz)
-(II) intel(0): Modeline "1024x768"x0.0   43.33  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (32.2 kHz)
-(II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
-(II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
-(II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
+(II) Power Button: Close
+(II) UnloadModule: "evdev"
+(II) Video Bus: Close
+(II) UnloadModule: "evdev"
+(II) Sleep Button: Close
+(II) UnloadModule: "evdev"
+(II) AT Translated Set 2 keyboard: Close
+(II) UnloadModule: "evdev"
+(II) PS/2 Generic Mouse: Close
+(II) UnloadModule: "evdev"
+(II) ThinkPad Extra Buttons: Close
+(II) UnloadModule: "evdev"
+(II) ACPI Virtual Keyboard Device: Close
+(II) UnloadModule: "evdev"


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
