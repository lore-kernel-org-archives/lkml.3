Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3FOURx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:17:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38646 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab3FOURv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:17:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Aaron Lu <aaron.lu@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Aaron Lu <aaron.lwe@gmail.com>, Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware expects Windows 8
Date: Sat, 15 Jun 2013 22:27:06 +0200
Message-ID: <6834259.1uPUZ8EFRd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130615182942.GA6424@phenom.ffwll.local>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <20130615151628.GA9868@srcf.ucam.org> <20130615182942.GA6424@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 08:29:42 PM Daniel Vetter wrote:
> Hi all,
> 
> So to me it looks like the discussion is going in circles a bit, hence let
> me drop my maintainer-opinion here:
> 
> 1. Matthew's patch series here looks reasonable, and if it fixes a bunch
> of systems (which it seems to) it has my Ack and imo should go in. If acpi
> maintainers can smash their Ack onto the acpi parts I'd very much like to
> merge this into drm-intel-next, that should give us the most coverage for
> intel systems.
> 
> Len, Rafael, are you ok with the acpi part of this and merging it through
> drm-intel-next?

It has to go through the ACPI tree because of the ACPICA patch that needs to
be synchronized with the ACPICA upstream.  Sorry.

That said, I'm going to take this patchset.

> 2. Imo the current amount of quirking we expose to users (we have kernel
> options to disable the acpi interface, blacklist platform modules, all
> backlights can be tested through sysfs and on top of that xf86-video-intel
> has an xorg.conf to select the backlight used by the driver). I haven't
> spotted a compelling reason in this thread to add another one, what we
> have seems to be good enough to debug backligh issues.
> 
> 3. Also, adding yet another backlight quirk mechanism isn't gonna
> magically fix broken systems.
> 
> We _really_ should strive to make this just work and not offer the angry
> user another roll of duct-tape for free.
> 
> 4. The currently established priority selection for backlights of platform
> > firmware > raw seems to be good enough. Note that the explicit list in
> xf86-vidoe-intel is only used as a fallback for really old kernels which
> do not expose this information. We could probably rip it out.
> 
> 5. We've recently looked at opregion again and couldn't spot a hint.
> Unfortnately it looks like both noodling better information out of Intel
> and trying to publish an updated opregion spec seem to be losing games :(
> We'll keep on trying though.
> 
> Aside at the end: If the gnome tool indeed has its own backlight code and
> doesn't just use that as a fallback if the xrandr backligh property isn't
> available, then that's just a serious bug in gnome and should be fixed
> asap. But imo that's not something we should try to (nor do I see any way
> how to) work around in the kernel.

Agreed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
