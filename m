Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaBTCVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:21:00 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54232 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBTCU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:20:59 -0500
MIME-Version: 1.0
Date: Wed, 19 Feb 2014 21:20:58 -0500
X-Google-Sender-Auth: JmheynGGx2wVvkxni7EdV-sEqNg
Message-ID: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
Subject: 3.13 i915 brightness settings broken when going from docked -> undocked
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a rather weird report[1] of the brightness adjustments being
broken in a specific case with Thinkpad x220 hardware (SandyBridge
based).  If you boot the machine with it in a dock and then undock,
the brightness adjustments do not work.  That is with either the FN
keys or the GNOME brightness slider.

I can see that the value of
/sys/class/backlight/acpi_video0/brightness increases/decreases but
/sys/class/backlight/intel_backlight/brightness doesn't reflect any
changes.  With 3.12 this works, and oddly with 3.14-rc1 it works
(specifically, it starts working around v3.13-10231-g53d8ab2 which is
right after the first DRM merge for 3.14).  With 3.13, if I undock and
echo a higher value in the intel_backlight_brightness sysfs entry, the
brightness will actually increase so it can be done manually, but it
does not work as you'd expect.

I'm in the middle of trying to do a reverse bisect for which patch
fixes it in the 3.14-rcX series, but that's taking a while.  I thought
I'd email and see if anyone already knows about this situation, what
patch in 3.13 broke this, and which one then fixed it again.  Thus far
all I've gathered is that backlight handling is confusing.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1067071
