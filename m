Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3GPLox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:44:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44682 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab3GPLow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:44:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-acpi@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
Date: Tue, 16 Jul 2013 13:54:45 +0200
Message-ID: <1395450.6I3SUHCKW9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E4BCD5.8040106@gmail.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <196299995.fotXCOt3dc@vostro.rjw.lan> <51E4BCD5.8040106@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 11:24:05 AM Aaron Lu wrote:
> On 07/15/2013 07:42 PM, Rafael J. Wysocki wrote:
> > On Monday, July 15, 2013 10:36:15 AM Aaron Lu wrote:
> >> On 07/13/2013 08:46 AM, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>
> >>> According to Matthew Garrett, "Windows 8 leaves backlight control up
> >>> to individual graphics drivers rather than making ACPI calls itself.
> >>> There's plenty of evidence to suggest that the Intel driver for
> >>> Windows [8] doesn't use the ACPI interface, including the fact that
> >>> it's broken on a bunch of machines when the OS claims to support
> >>> Windows 8.  The simplest thing to do appears to be to disable the
> >>> ACPI backlight interface on these systems".
> >>>
> >>> There's a problem with that approach, however, because simply
> >>> avoiding to register the ACPI backlight interface if the firmware
> >>> calls _OSI for Windows 8 may not work in the following situations:
> >>>  (1) The ACPI backlight interface actually works on the given system
> >>>      and the i915 driver is not loaded (e.g. another graphics driver
> >>>      is used).
> >>>  (2) The ACPI backlight interface doesn't work on the given system,
> >>>      but there is a vendor platform driver that will register its
> >>>      own, equally broken, backlight interface if not prevented from
> >>>      doing so by the ACPI subsystem.
> >>> Therefore we need to allow the ACPI backlight interface to be
> >>> registered until the i915 driver is loaded which then will unregister
> >>> it if the firmware has called _OSI for Windows 8 (or will register
> >>> the ACPI video driver without backlight support if not already
> >>> present).
> >>>
> >>> For this reason, introduce an alternative function for registering
> >>> ACPI video, acpi_video_register_with_quirks(), that will check
> >>> whether or not the ACPI video driver has already been registered
> >>> and whether or not the backlight Windows 8 quirk has to be applied.
> >>> If the quirk has to be applied, it will block the ACPI backlight
> >>> support and either unregister the backlight interface if the ACPI
> >>> video driver has already been registered, or register the ACPI
> >>> video driver without the backlight interface otherwise.  Make
> >>> the i915 driver use acpi_video_register_with_quirks() instead of
> >>> acpi_video_register() in i915_driver_load().
> >>>
> >>> This change is based on earlier patches from Matthew Garrett,
> >>> Chun-Yi Lee and Seth Forshee and Aaron Lu's comments.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> Reviewed-by: Aaron Lu <aaron.lu@intel.com>
> >>
> >> BTW, I also tested on a Toshiba laptop Z830 where its AML code
> >> claims support of win8, the result is as expected: ACPI video
> >> interface is removed, i915 Xorg driver picks intel_backlight.
> >>
> >> Thanks for the fix.
> > 
> > Cool, thanks for testing this!
> > 
> > Can you please also ask bug reporters in the BZ entires related to this to test
> > it too?
> 
> Sure.
> 
> To be clear, I actually tested the patch in your linux-next branch,
> which turned out to be a little different in that you have fixed the
> problem Igor raised here.
> 
> I'll ask reporters to test on a stable tree with the following two
> patches on top:
> https://patchwork.kernel.org/patch/2812951/ (expose OSI version)
> https://patchwork.kernel.org/patch/2827793/ (your updated patch)
> or your linux-next branch, whichever they like.

OK

Thanks,
Rafael

