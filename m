Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaBTHxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:53:43 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61467 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbaBTHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:53:41 -0500
Message-ID: <1392882819.5070.15.camel@x220>
Subject: Re: 3.13 i915 brightness settings broken when going from docked ->
 undocked
From: Paul Bolle <pebolle@tiscali.nl>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Feb 2014 08:53:39 +0100
In-Reply-To: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 07:53:39.0752 (UTC) FILETIME=[DE184280:01CF2E10]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 21:20 -0500, Josh Boyer wrote:
> We've had a rather weird report[1] of the brightness adjustments being
> broken in a specific case with Thinkpad x220 hardware (SandyBridge
> based).  If you boot the machine with it in a dock and then undock,
> the brightness adjustments do not work.  That is with either the FN
> keys or the GNOME brightness slider.

On an (rather old) ThinkPad X41, which also uses i915, brightness
adjustments stopped working altogether in v3.14-rc1 (I haven't used its
docking station in the v3.14 release cycle). In v3.13.y things behave as
expected. So perhaps there's actually a more general problem here.

> I can see that the value of
> /sys/class/backlight/acpi_video0/brightness

On the X41 I check /proc/acpi/ibm/brightness ...

>  increases/decreases but
> /sys/class/backlight/intel_backlight/brightness doesn't reflect any
> changes.

but otherwise things look similar.

>  With 3.12 this works, and oddly with 3.14-rc1 it works
> (specifically, it starts working around v3.13-10231-g53d8ab2 which is
> right after the first DRM merge for 3.14).  With 3.13, if I undock and
> echo a higher value in the intel_backlight_brightness sysfs entry, the
> brightness will actually increase so it can be done manually, but it
> does not work as you'd expect.

Echoing values into /sys/class/backlight/intel_backlight/brightness
works too (that's a new trick for me!). But, again, no docking station
is required, so the problem looks less odd than the problem on that
x220.

> I'm in the middle of trying to do a reverse bisect for which patch
> fixes it in the 3.14-rcX series, but that's taking a while.  I thought
> I'd email and see if anyone already knows about this situation, what
> patch in 3.13 broke this, and which one then fixed it again.  Thus far
> all I've gathered is that backlight handling is confusing.

I haven't yet tried bisecting.

> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1067071


Paul Bolle

