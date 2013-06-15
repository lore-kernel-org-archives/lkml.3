Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3FOS37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 14:29:59 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47110 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3FOS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 14:29:58 -0400
Date: Sat, 15 Jun 2013 20:29:42 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Aaron Lu <aaron.lu@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Message-ID: <20130615182942.GA6424@phenom.ffwll.local>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Aaron Lu <aaron.lu@intel.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
	Alex Deucher <alexdeucher@gmail.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
 <51BABC6F.3050201@intel.com>
 <1371230988.2490.2.camel@x230>
 <51BBC2E1.9040401@intel.com>
 <1371260284.523.2.camel@x230>
 <51BBEA32.1040002@intel.com>
 <20130615041945.GA4756@srcf.ucam.org>
 <51BC5E1B.2020400@intel.com>
 <20130615151628.GA9868@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615151628.GA9868@srcf.ucam.org>
X-Operating-System: Linux phenom 3.10.0-rc5+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

So to me it looks like the discussion is going in circles a bit, hence let
me drop my maintainer-opinion here:

1. Matthew's patch series here looks reasonable, and if it fixes a bunch
of systems (which it seems to) it has my Ack and imo should go in. If acpi
maintainers can smash their Ack onto the acpi parts I'd very much like to
merge this into drm-intel-next, that should give us the most coverage for
intel systems.

Len, Rafael, are you ok with the acpi part of this and merging it through
drm-intel-next?

2. Imo the current amount of quirking we expose to users (we have kernel
options to disable the acpi interface, blacklist platform modules, all
backlights can be tested through sysfs and on top of that xf86-video-intel
has an xorg.conf to select the backlight used by the driver). I haven't
spotted a compelling reason in this thread to add another one, what we
have seems to be good enough to debug backligh issues.

3. Also, adding yet another backlight quirk mechanism isn't gonna
magically fix broken systems.

We _really_ should strive to make this just work and not offer the angry
user another roll of duct-tape for free.

4. The currently established priority selection for backlights of platform
> firmware > raw seems to be good enough. Note that the explicit list in
xf86-vidoe-intel is only used as a fallback for really old kernels which
do not expose this information. We could probably rip it out.

5. We've recently looked at opregion again and couldn't spot a hint.
Unfortnately it looks like both noodling better information out of Intel
and trying to publish an updated opregion spec seem to be losing games :(
We'll keep on trying though.

Aside at the end: If the gnome tool indeed has its own backlight code and
doesn't just use that as a fallback if the xrandr backligh property isn't
available, then that's just a serious bug in gnome and should be fixed
asap. But imo that's not something we should try to (nor do I see any way
how to) work around in the kernel.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
