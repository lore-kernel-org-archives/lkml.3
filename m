Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaLHCcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 21:32:06 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46748 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHCcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 21:32:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141208003433.GA3353@thunk.org>
References: <20140902040527.GA5508@thunk.org>
	<20141208003433.GA3353@thunk.org>
Date: Mon, 8 Dec 2014 12:32:01 +1000
Message-ID: <CAPM=9txGrrqYPg9EbpC+9OAB5VCt36vWFRMmoAOvJZV-RSQ2-A@mail.gmail.com>
Subject: Re: WARNING: /usr/projects/linux/linux/drivers/gpu/drm/i915/intel_pm.c:6585
 intel_display_power_put+0x4b/0x116 [i915]()
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2014 at 10:34, Theodore Ts'o <tytso@mit.edu> wrote:
> This is an update to a problem which I reported several months ago
> (see below).  The symptoms have changed a bit since then, but they've
> stablized since 3.17 and 3.18-rcX, and while annoying, it's tolerable,
> so I've been living with it.
>
> What I'm basically seeing now is that any external monitor (either a
> Dell 30" or Dell 24") will be seen after a reboot or a restart of the
> X server.  But if suspend the laptop, disconnect from the dock, and
> resume, and then later on, reconnect to the dock, the external
> monitors are not visible until I kill and restart the X server.
> Another part of the symptom is when I try to probe for the monitors,
> using either xrandr or xfce4-display-settings, the system freezes for
> a second or two, and then when it recovers, if I look in the logs, I
> see the following warning message, repeated twice:

I suspect a lot of the problems are just that xfce isn't sufficiently handling
randr events, and it is getting out of sync, it is like hotplug networking
before NetworkManager etc.

I just tried using XFCE from F21 and if I leave the display settings app
open it crashes hard when I tried the cycle above, which didn't lend
me much confidence, it also never reenabled the monitor when it came
back,

I've tried a few cycles of this with GNOME desktop and it seems to
work pretty well.

I'll try reproducing the exact problem you are seeing however,

I haven't managed that with drm-next tree which has v3.18 merged now.

The i915 driver also has a tendency to WARN_ON on pointless things,
the i915 developers insist these are actual bugs, but don't insist on producing
patches to fix them in a reasonable time frame or if they do, they add
5 more WARN_ONs to compensate.

Dave.
