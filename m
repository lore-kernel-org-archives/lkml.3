Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaBUAbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:31:46 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61169 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaBUAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:31:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
Date: Thu, 20 Feb 2014 19:31:41 -0500
X-Google-Sender-Auth: hEzlJNQ39BsUDmoG0-vM_EtSLuM
Message-ID: <CA+5PVA6Td43Zzd8L59_mE7E5hFuVSxhAwd+tczs_BSHXNOx5yw@mail.gmail.com>
Subject: Re: 3.13 i915 brightness settings broken when going from docked -> undocked
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 9:20 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi All,
>
> We've had a rather weird report[1] of the brightness adjustments being
> broken in a specific case with Thinkpad x220 hardware (SandyBridge
> based).  If you boot the machine with it in a dock and then undock,
> the brightness adjustments do not work.  That is with either the FN
> keys or the GNOME brightness slider.
>
> I can see that the value of
> /sys/class/backlight/acpi_video0/brightness increases/decreases but
> /sys/class/backlight/intel_backlight/brightness doesn't reflect any
> changes.  With 3.12 this works, and oddly with 3.14-rc1 it works
> (specifically, it starts working around v3.13-10231-g53d8ab2 which is
> right after the first DRM merge for 3.14).  With 3.13, if I undock and
> echo a higher value in the intel_backlight_brightness sysfs entry, the
> brightness will actually increase so it can be done manually, but it
> does not work as you'd expect.
>
> I'm in the middle of trying to do a reverse bisect for which patch
> fixes it in the 3.14-rcX series, but that's taking a while.  I thought
> I'd email and see if anyone already knows about this situation, what
> patch in 3.13 broke this, and which one then fixed it again.  Thus far
> all I've gathered is that backlight handling is confusing.

The reverse bisect between 3.13 and 3.14-rc1 didn't prove fruitful,
either because I messed it up or there's a combination of things that
fix the issue.  So instead I did a regular git bisect between 3.12 and
3.13 to see which commit _broke_ things and caused the above behavior.
 That landed me at:

Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Oct 31 18:55:49 2013 +0200

    drm/i915: make backlight functions take a connector

I have no idea if that makes sense or not, but it's at least something
that seems to be in a relevant area of code.  Does anyone involved in
that know why it would cause the above symptoms on 3.13, and which
commit(s) fix it in 3.14-rc1?

josh
