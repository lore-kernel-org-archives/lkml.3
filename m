Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3IIPVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:21:11 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36559 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3IIPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:21:06 -0400
Date: Mon, 9 Sep 2013 17:21:18 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Vetter <daniel@ffwll.ch>, Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Message-ID: <20130909152118.GG27291@phenom.ffwll.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Aaron Lu <aaron.lu@intel.com>,
	ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	Igor Gnatenko <i.gnatenko.brain@gmail.com>,
	Yves-Alexis Perez <corsac@debian.org>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Lee Chun-Yi <jlee@novell.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <522D88C3.7000808@intel.com>
 <522D89EC.6050103@intel.com>
 <20130909093209.GF27291@phenom.ffwll.local>
 <1793135.3qk7NfcINN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1793135.3qk7NfcINN@vostro.rjw.lan>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:16:12PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Monday, September 09, 2013 11:32:10 AM Daniel Vetter wrote:
> > Hi Aaaron,
> > 
> > Have we grown any clue meanwhile about which Intel boxes need this and for
> > which we still need to keep the acpi backlight around?
> 
> First of all, there is a bunch of boxes where ACPI backlight works incorrectly
> because of the Win8 compatibility issue.  [In short, if we say we are compatible
> with Win8, the backlight AML goes into a special code path that is broken on
> those machines. Presumably Win8 uses native backlight control on them and that
> AML code path is never executed there.]  The collection of machines with this
> problem appears to be kind of random (various models from various vendors), but
> I *think* they are machines that originally shipped with Win7 with a Win8
> "upgrade" option (which in practice requires the BIOS to be updated anyway).
> 
> Because of that, last time we tried to switch all of the systems using i915
> and telling the BIOS that they are compatible with Win8 over to native backlight
> control, but that didn't work for two reasons.  The first reason is that some
> user space doesn't know how to use intel_backlight and needs to be taught about
> that (so some systems are just not ready for that switch).  The second and more
> fundamental reason is that the native backlight control simply doesn't work on
> some machines and we don't seem to have any idea why and how to debug this
> particular problem (mostly because we don't have enough information and we
> don't know what to ask for).
> 
> > I've grown _very_ reluctant to just adding tons of quirks to our driver for
> > the backlight.
> >
> > Almost all the quirks we have added recently (or that have been proposed
> > to be added) are for the backlight. Imo that indicates we get something
> > fundamentally wrong ...
> 
> This thing isn't really a quirk.  It rather is an option for the users of
> the systems where ACPI backlight doesn't work to switch over to the native
> backlight control using a command line switch.  This way they can at least
> *see* if the native backlight control works for them and (hopefully) report
> problems if that's not the case.  This gives us a chance to get more
> information about what the problem is and possibly to make some progress
> without making changes for everyone, reverting those changes when they don't
> work etc.
> 
> An alternative for them is to pass acpi_osi="!Windows 2012" which will probably
> make the ACPI backlight work for them again, but this rather is a step back,
> because we can't possibly learn anything new from that.

If Win8 is as broken as we are I'm ok with the module option. It just
sounded to me like right now we don't know of a way to make all machines
somewhat happy, combined with the other pile of random backlight issues
the assumption that we do something (maybe something a bit racy) that
windows doesn't do isn't too far-fetched. So I'm not wary of the machines
where the aml is busted for acpi_os=win8, but for the others where this
broke stuff.

Or do I miss something here?

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
