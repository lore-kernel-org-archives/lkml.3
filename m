Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3JNDtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:49:32 -0400
Received: from tango.0pointer.de ([85.214.72.216]:42298 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3JNDta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:49:30 -0400
Date: Mon, 14 Oct 2013 05:49:28 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
  detect blacklist
Message-ID: <20131014034927.GA3638@tango.0pointer.de>
References: <20131014005505.GA30503@tango.0pointer.de>
 <525B44C0.3010204@intel.com>
 <20131014022325.GA2248@tango.0pointer.de>
 <525B58BE.5050009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525B58BE.5050009@intel.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14.10.13 10:36, Aaron Lu (aaron.lu@intel.com) wrote:

> > - Backlight control doesn't work via ACPI without acpi_osi="!Windows 2012"
> > - Backlight control doesn't work via ACPI with acpi_osi="!Windows 2012"
> > - Backlight control doesn't work via EC commands from ideapad-laptop.c
> > 
> > The only way backlight handling is supported on the Yoga 13 is via the
> > intel video driver.
> 
> Since I don't have access to the acpidump of this system, my only
> question is, does the firmware has a _OSI("Windows 2012") query in DSDT
> table?

Yes, it appears to do that as part of _OSC.

The disassembled DSDT table is here:

http://0pointer.de/public/yoga13-dsdt.dsl

> > Or in other words: the situation for the Yoga 13 is *unrelated* to the
> > Windows 8 issues, and your patch.
> 
> I think they are related...
> If the firmware is compatible to Windows 8, then my patch will disable
> ACPI video backlight interface to prefer GPU's interface.

OK, that might indeed work.

> > I'll soon send another patch which also blacklists the thing in the
> > ideapad driver, so that only the intel backlight driver is enabled on
> > Yoga 13 systems, at which point everything will work fine.
> 
> Right, that is needed. And if going with my patch, the ideapad driver
> will need to be patched similarly like thinkpad_acpi to add a check of
> acpi_video_backlight_support before it decides to register its own
> backlight interface.

The ideapad driver currently skips registration of the backlight device
if acpi_video_backlight_support() returns true. is that all you need?

Hmm, regarding your patch series, do you plan to skip the registration
of the acpi backlight device if the "raw" device is supported? I mean,
the intel driver could be compiled as a module (and generally is on the
popular distros), so at the time the ACPI subsystem wants to register
the backlight device and know if a raw backlight device is around it
never will be, so what is the point of that? Or am I missing something?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
