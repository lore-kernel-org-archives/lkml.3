Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3JNCcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:32:33 -0400
Received: from tango.0pointer.de ([85.214.72.216]:41799 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3JNCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:32:32 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Oct 2013 22:32:32 EDT
Date: Mon, 14 Oct 2013 04:23:25 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
  detect blacklist
Message-ID: <20131014022325.GA2248@tango.0pointer.de>
References: <20131014005505.GA30503@tango.0pointer.de>
 <525B44C0.3010204@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525B44C0.3010204@intel.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14.10.13 09:11, Aaron Lu (aaron.lu@intel.com) wrote:

> > Note that this appears unrelated to the Windows 8 backlight issues tracked
> > here:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=51231
> > https://bugzilla.kernel.org/show_bug.cgi?id=60682
> > 
> > The Yoga's ACPI backlight controls work neither with nor without
> > acpi_osi="!Windows 2012" on the kernel command line. It appears that
> > backlight control via the EC simply is not available at all, regardless
> > whether done via ACPI or via the vendor driver.
> 
> Just a side note, if the firmware of Yoga 13 has a _OSI("Windows 2012")
> query, then it should be solved with the patch proposed here:
> https://lkml.org/lkml/2013/10/11/409, Fix Win8 backlight issue.
> 
> We are still discussing a proper default behaviour in that patchset.

No. 

Did you actually read the commit message of the patch? Please do!

The backlight for the Yoga 13 doesn't work, regardless what the _OSI
value is. In fact, it doesn't even work by directly accessing the EC via
the ideapad-laptop driver. 

So, again:

- Backlight control doesn't work via ACPI without acpi_osi="!Windows 2012"
- Backlight control doesn't work via ACPI with acpi_osi="!Windows 2012"
- Backlight control doesn't work via EC commands from ideapad-laptop.c

The only way backlight handling is supported on the Yoga 13 is via the
intel video driver.

Or in other words: the situation for the Yoga 13 is *unrelated* to the
Windows 8 issues, and your patch.

Hence this patch I posted, which blacklists the backlight control
entirely in the ACPI driver, since the Windows 2012 setting is
irrelevant to it.

I'll soon send another patch which also blacklists the thing in the
ideapad driver, so that only the intel backlight driver is enabled on
Yoga 13 systems, at which point everything will work fine.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
