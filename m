Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3ILCZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:25:53 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44409 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3ILCZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:25:51 -0400
Date: Thu, 12 Sep 2013 10:26:12 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Vetter <daniel@ffwll.ch>,
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
Message-ID: <20130912022611.GA11167@aaronlu.sh.intel.com>
References: <522D88C3.7000808@intel.com>
 <5155010.Y1gov7SKhP@vostro.rjw.lan>
 <87eh8wail7.fsf@intel.com>
 <1889567.vxI8heiC3B@vostro.rjw.lan>
 <20130911013206.GA556@mint-spring.sh.intel.com>
 <87hadrycf4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hadrycf4.fsf@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:45:19AM +0300, Jani Nikula wrote:
> On Wed, 11 Sep 2013, Aaron Lu <aaron.lu@intel.com> wrote:
> > It is possible the i915 driver decides not to register a backlight
> > interface for the graphics card for some reason(memory allocation failed
> > or it knows the native control does not work on this card or whatever),
> > so I would prefer let i915 tell ACPI video that it has registered a
> > native backlight control interface as Jani has said.
> >
> > Then together with the video.use_native_backlight, we can register or
> > not register ACPI video backlight interface accordingly. Or rather, we
> > can simply not register ACPI video backlight interface for Win8 systems
> > as long as i915 indicates that it has native backlight control(if the
> > native control is broken, i915 should fix it or blacklist it so that
> > i915 will not indicate it has native backlight control and ACPI video
> > will continue to register its own).
> >
> > How does this sound?
> 
> Sounds good to me.
> 
> Before plunging forward, have you observed any difference between the
> boot modes? We have reports [1] that the backlight behaviour is

Not yet from ACPI's point of view.

> different with UEFI vs. UEFI+CSM or legacy boot. So I'm wondering if the
> acpi_gbl_osi_data >= ACPI_OSI_WIN_8 check in patch 2/2 is the whole
> story.

This check in patch 2/2 is a policy: for Win8 system, we think the
native backlight control has a better chance of working than the ACPI
video's, so I think the check is enough in ACPI video.

> 
> Further, if we tell the BIOS we're Windows 8 to use the tested BIOS code
> paths, what guarantees do we have of UEFI+CSM or legacy boots working?

I suppose the 'tested BIOS code paths' means the pure UEFI boot mode? I
don't know what guatantees do we have since I don't know what happened
underneath after the backlight register is set in i915 driver, you or
other i915 driver people should know more than I do :-)

BTW, after the backlight register is set in i915, is it that some
find of firmware code will run in response to the setting of the
register(e.g. the BLC_PWM_CTL/BLC_PWM_CPU_CTL/PCI_LBPC reg)?

Thanks,
Aaron
