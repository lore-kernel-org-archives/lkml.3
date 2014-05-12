Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaELDxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:53:19 -0400
Received: from psychosnugglebunnies.net ([216.75.44.53]:56757 "EHLO
	nietzsche.psychosnugglebunnies.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaELDxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:53:18 -0400
X-Greylist: delayed 2560 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2014 23:53:18 EDT
Date: Sun, 11 May 2014 20:10:29 -0700
From: Carbonated Beverage <ramune@psychosnugglebunnies.net>
To: linux-kernel@vger.kernel.org
Subject: 3.14.3 i915 dead display under X11
Message-ID: <20140512031029.GA18875@psychosnugglebunnies.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ramune@psychosnugglebunnies.net
X-SA-Exim-Scanned: No (on nietzsche.psychosnugglebunnies.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I rarely upgrade kernels these days -- so when updating to 3.14.3, I found
the X display was blank -- switching to a text console appears to work, but
I still have to type blind.

Symptoms:

Text mode and KMS works correctly to come up with the text console.  Running
X (whether through xdm or /usr/bin/Xorg) causes the display to go blank
and apparently turn off.  Switching to a text console via Control-Alt-F#
leaves a mostly blank screen up, but there are brief flashes where it looks
like the contents of the text console gets rendered once every 5 seconds or so,
but so fast no words or letters can be recognized.

System:

* Thinkpad R61
* 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (primary) (rev 0c)
* Debian/wheezy
* xserver-xorg-video-intel 2:2.19.0-6

A diff of the Xorg.0.log (with timestamps removed, as it made almost every line
show up in the diff) trimmed down shows:

@@ -53,7 +53,7 @@
  (==) |-->Input Device "<default keyboard>"
  (==) The core keyboard device wasn't specified explicitly in the layout.
 	Using the default keyboard configuration.
- (II) Loader magic: 0x7f2813451ae0
+ (II) Loader magic: 0x7f492c35aae0
  (II) Module ABI versions:
  	X.Org ANSI C Emulation: 0.4
  	X.Org Video Driver: 12.1
@@ -170,15 +170,17 @@
 	Sandybridge Server, Ivybridge Mobile (GT1), Ivybridge Mobile (GT2),
 	Ivybridge Desktop (GT1), Ivybridge Desktop (GT2), Ivybridge Server,
 	Ivybridge Server (GT2)
- (--) using VT number 7
+ (++) using VT number 7
 
+ (WW) xf86OpenConsole: setpgid failed: Operation not permitted
+ (WW) xf86OpenConsole: setsid failed: Operation not permitted
  (WW) VGA arbiter: cannot open kernel arbiter, no multi-card support
  drmOpenDevice: node name is /dev/dri/card0
- drmOpenDevice: open result is 10, (OK)
+ drmOpenDevice: open result is 8, (OK)
  drmOpenByBusid: Searching for BusID pci:0000:00:02.0
  drmOpenDevice: node name is /dev/dri/card0
- drmOpenDevice: open result is 10, (OK)
- drmOpenByBusid: drmOpenMinor returns 10
+ drmOpenDevice: open result is 8, (OK)
+ drmOpenByBusid: drmOpenMinor returns 8
  drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
  (**) intel(0): Depth 16, (--) framebuffer bpp 16
  (==) intel(0): RGB weight 565
@@ -387,7 +389,17 @@
  (II) AutoAddDevices is off - not adding device.
  (II) config/udev: Adding input device ThinkPad Extra Buttons (/dev/input/event5)
  (II) AutoAddDevices is off - not adding device.
- (II) AIGLX: Suspending AIGLX clients for VT switch
- (II) UnloadModule: "kbd"
- (II) UnloadModule: "mouse"
- Server terminated successfully (0). Closing log file.
+ (II) intel(0): EDID vendor "LEN", prod id 16435
+ (II) intel(0): Printing DDC gathered Modelines:
+ (II) intel(0): Modeline "1440x900"x0.0   97.78  1440 1488 1520 1760  900 903 909 926 -hsync -vsync (55.6 kHz eP)
+ (II) intel(0): Modeline "1440x900"x0.0   81.49  1440 1488 1520 1760  900 903 909 926 -hsync -vsync (46.3 kHz e)
+ (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
+ (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
+ (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
+ (II) intel(0): EDID vendor "LEN", prod id 16435
+ (II) intel(0): Printing DDC gathered Modelines:
+ (II) intel(0): Modeline "1440x900"x0.0   97.78  1440 1488 1520 1760  900 903 909 926 -hsync -vsync (55.6 kHz eP)
+ (II) intel(0): Modeline "1440x900"x0.0   81.49  1440 1488 1520 1760  900 903 909 926 -hsync -vsync (46.3 kHz e)
+ (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
+ (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
+ (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)

Bisecting from 3.13.6 (good) to 3.14.3 (bad) ended up with...

commit b35684b8fa94e04f55fd38bf672b737741d2f9e2
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Thu Nov 14 12:13:41 2013 +0200

    drm/i915: do full backlight setup at enable time
    
    We should now have all the information we need to do a full
    initialization of the backlight registers.
    
    v2: Keep QUIRK_NO_PCH_PWM_ENABLE for now (Imre).
    
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>
    Reviewed-by: Imre Deak <imre.deak@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Which is in 3.12.0????

I'm not sure how that came to be.  Does that look right?  What other
information would be required to track this down?

Thanks,

-- DN
Daniel Nobuto
