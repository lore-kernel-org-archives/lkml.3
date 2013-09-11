Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3IKBfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:35:02 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65462 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3IKBfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:35:00 -0400
Date: Wed, 11 Sep 2013 09:32:11 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Daniel Vetter <daniel@ffwll.ch>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Message-ID: <20130911013206.GA556@mint-spring.sh.intel.com>
References: <522D88C3.7000808@intel.com>
 <5155010.Y1gov7SKhP@vostro.rjw.lan>
 <87eh8wail7.fsf@intel.com>
 <1889567.vxI8heiC3B@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1889567.vxI8heiC3B@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:23:04PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 10, 2013 04:53:40 PM Jani Nikula wrote:
> > On Mon, 09 Sep 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > On Monday, September 09, 2013 05:21:18 PM Daniel Vetter wrote:
> > >> On Mon, Sep 09, 2013 at 02:16:12PM +0200, Rafael J. Wysocki wrote:
> > >> > Hi,
> > >> > 
> > >> > On Monday, September 09, 2013 11:32:10 AM Daniel Vetter wrote:
> > >> > > Hi Aaaron,
> > >> > > 
> > >> > > Have we grown any clue meanwhile about which Intel boxes need this and for
> > >> > > which we still need to keep the acpi backlight around?
> > >> > 
> > >> > First of all, there is a bunch of boxes where ACPI backlight works incorrectly
> > >> > because of the Win8 compatibility issue.  [In short, if we say we are compatible
> > >> > with Win8, the backlight AML goes into a special code path that is broken on
> > >> > those machines. Presumably Win8 uses native backlight control on them and that
> > >> > AML code path is never executed there.]  The collection of machines with this
> > >> > problem appears to be kind of random (various models from various vendors), but
> > >> > I *think* they are machines that originally shipped with Win7 with a Win8
> > >> > "upgrade" option (which in practice requires the BIOS to be updated anyway).
> > >> > 
> > >> > Because of that, last time we tried to switch all of the systems using i915
> > >> > and telling the BIOS that they are compatible with Win8 over to native backlight
> > >> > control, but that didn't work for two reasons.  The first reason is that some
> > >> > user space doesn't know how to use intel_backlight and needs to be taught about
> > >> > that (so some systems are just not ready for that switch).  The second and more
> > >> > fundamental reason is that the native backlight control simply doesn't work on
> > >> > some machines and we don't seem to have any idea why and how to debug this
> > >> > particular problem (mostly because we don't have enough information and we
> > >> > don't know what to ask for).
> > >> > 
> > >> > > I've grown _very_ reluctant to just adding tons of quirks to our driver for
> > >> > > the backlight.
> > >> > >
> > >> > > Almost all the quirks we have added recently (or that have been proposed
> > >> > > to be added) are for the backlight. Imo that indicates we get something
> > >> > > fundamentally wrong ...
> > >> > 
> > >> > This thing isn't really a quirk.  It rather is an option for the users of
> > >> > the systems where ACPI backlight doesn't work to switch over to the native
> > >> > backlight control using a command line switch.  This way they can at least
> > >> > *see* if the native backlight control works for them and (hopefully) report
> > >> > problems if that's not the case.  This gives us a chance to get more
> > >> > information about what the problem is and possibly to make some progress
> > >> > without making changes for everyone, reverting those changes when they don't
> > >> > work etc.
> > >> > 
> > >> > An alternative for them is to pass acpi_osi="!Windows 2012" which will probably
> > >> > make the ACPI backlight work for them again, but this rather is a step back,
> > >> > because we can't possibly learn anything new from that.
> > >> 
> > >> If Win8 is as broken as we are I'm ok with the module option. It just
> > >> sounded to me like right now we don't know of a way to make all machines
> > >> somewhat happy, combined with the other pile of random backlight issues
> > >> the assumption that we do something (maybe something a bit racy) that
> > >> windows doesn't do isn't too far-fetched. So I'm not wary of the machines
> > >> where the aml is busted for acpi_os=win8, but for the others where this
> > >> broke stuff.
> > >> 
> > >> Or do I miss something here?
> > >
> > > The ACPI video driver doesn't do anything new now.  It only does things that
> > > did work before we started to tell BIOSes we're compatible with Win8.  The
> > > reason why they don't work on some machines now is not related to whether or
> > > not Win8 is broken, but to what is there in the ACPI tables on those machines.
> > > That *is* pure garbage, but Win8 users don't see that (presumably, because
> > > Win8 does't execute the AML in question).  We don't see that either with
> > > acpi_osi="!Windows 2012" (because then we don't execute that AML either).
> > >
> > > Whether or not Win8 is broken doesn't matter here.  What matters is that we
> > > have to deal with broken AML somehow.
> > >
> > > One way may be to tell everyone affected by this to pass
> > > acpi_osi="!Windows 2012" in the kernel command line or possibly create a
> > > blacklist of those machines in the kernel (which Felipe has been pushing for
> > > recently) and wash our hands clean of this, but that leaves some exceptionally
> > > bad taste in my mouth.
> > >
> > > The alternative is to try to use native backlight in i915, which we did, but
> > > that didn't work on some machines.  I don't think we will know why it didn't
> > > work there before we collect some more information and that's not possible
> > > without user testing.  So, the idea is to make that testing possible without
> > > hacking the kernel and that's why we're introducing the new command line
> > > switch.  And we're going to ask users to try it and report back.
> > 
> > The thing that slightly bugs me with the proposed patches is that
> > they're adding a module parameter to i915 to tell ACPI video driver
> > whether to quirk the backlight or not. Before you know, we *will* have
> > requests to add quirks to i915 to tell ACPI video driver this.
> > 
> > I think the parameter "Does the ACPI backlight interface work or not"
> > belongs to the ACPI video driver.
> >
> > Feel free to file this in your bikeshedding folder, but I think i915
> > should only tell ACPI "I have a native backlight interface".
> 
> It kind of does that already through the intel_opregion_init() thing,
> so it would be trivial to test intel_opregion_present() in
> acpi_video_register().

It is possible the i915 driver decides not to register a backlight
interface for the graphics card for some reason(memory allocation failed
or it knows the native control does not work on this card or whatever),
so I would prefer let i915 tell ACPI video that it has registered a
native backlight control interface as Jani has said.

Then together with the video.use_native_backlight, we can register or
not register ACPI video backlight interface accordingly. Or rather, we
can simply not register ACPI video backlight interface for Win8 systems
as long as i915 indicates that it has native backlight control(if the
native control is broken, i915 should fix it or blacklist it so that
i915 will not indicate it has native backlight control and ACPI video
will continue to register its own).

How does this sound?

-Aaron

> 
> So yes, we can add a command line option, say 'use_native_backlight' to the
> ACPI video driver that will work like this: "if the Intel opregion is present
> and video.use_native_backlight is set, skip registering ACPI backlight".
> 
> Is that what you want?
> 
> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
