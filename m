Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3HGMo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:44:58 -0400
Received: from smtp1.uu.se ([130.238.7.54]:40401 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450Ab3HGMo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:44:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20994.16485.195079.28369@pilspetsen.it.uu.se>
Date: Wed, 7 Aug 2013 14:41:09 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [3.11-rc4] Possible problem with nouveau drm driver and interrupts on Dell Latitude E6510
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Latitude E6510 has the following graphics HW:

01:00.0 VGA compatible controller: nVidia Corporation GT218 [NVS 3100M] (rev a2) (prog-if 00 [VGA controller])
        Subsystem: Dell Latitude E6510
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at e2000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at e0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at 7000 [size=128]
        Expansion ROM at e3000000 [disabled] [size=512K]
        Capabilities: <access denied>
        Kernel driver in use: nouveau

User-space is Fedora 17.  No proprietary drivers of any kind.

Up to the 3.11-rc2 kernel I never had any problems with it.

With 3.11-rc4 I've twice so far had the following problem:

0. X has been running for a while with fvwm, a couple of xterms, emacs, firefox, and xclock.

1. Suddenly text scrolling in xterm or emacs becomes extremely slow and grinds to a halt.
   Moving the mouse (which generates interrupts) resumes the scrolling, but then it stops
   again unless I keep moving the mouse.

2. At this time there are no kernel messages indicating problems.

3. If I exit X then the console behaves normally.

4. If I try to start X again it paints the background of my desktop and shows the mouse cursor,
   but nothing else comes up and it's unresponsive to mouse or keyboard input.
   I have to press C-A-D or the power button at this point.

5. After 1. above occurs, even a warm reboot isn't enough to make X work again.  A full
   power-cycled reboot is needed to bring the machine back to normal.

/Mikael
