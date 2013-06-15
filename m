Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3FOETw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 00:19:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35166 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3FOETv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 00:19:51 -0400
Date: Sat, 15 Jun 2013 05:19:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
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
Message-ID: <20130615041945.GA4756@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
 <51BABC6F.3050201@intel.com>
 <1371230988.2490.2.camel@x230>
 <51BBC2E1.9040401@intel.com>
 <1371260284.523.2.camel@x230>
 <51BBEA32.1040002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BBEA32.1040002@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:14:42PM +0800, Aaron Lu wrote:
> On 06/15/2013 09:38 AM, Matthew Garrett wrote:
> > Well, Windows 8 will only use the ACPI backlight interface if the GPU
> > driver decides to, right? So the logic for deciding whether to remove
> > the ACPI backlight control or not should be left up to the GPU. There's
> 
> I don't know this. From the document I googled, Microsoft suggests under
> win8, backlight should be controlled by the graphics driver for smooth
> brightness level change, instead of ACPI or other methods. So it is
> possible that OEM will not test the ACPI interface well and thus the
> interface is likely broken. I don't see why GPU driver has any better
> knowledge on which systems the firmware interface is broken or not.

The vendor will presumably have tested that backlight control works - if 
the GPU driver uses the ACPI interface and backlight control is broken, 
then the vendor would fix it.

> > no harm in refusing to expose a working method if there's another
> > working method, but there is harm in exposing a broken one and expecting
> > userspace to know the difference.
> 
> BTW, the proposed solution is not meant to solve win8 problems alone, it
> should make solving other problems easy and make individual backlight
> control interface provider module independent with each other such as
> the platform drivers will not need to check if ACPI video driver will
> control backlight or not and can always create backlight interface(its
> default priority is lower that ACPI video driver's so will not be taken
> by user space by default, showing the same behavior of the current code).

Sure, but it still requires the replacement of existing userspace. We 
need to fix the problem with existing userspace, too.

> The current acpi_backlight=video/vendor kernel command line is pretty
> misleading, for laptops that do not have vendor backlight interface,
> adding acpi_backlight=vendor actually makes the system using the GPU's
> interface. Some laptops are using this switch to work around problems in
> ACPI video driver and users think they are using vendor interface.
> That's why I think we need a new command line as the
> backlight.force_interface=raw/firmware/platform.

No, I think we need to fix the bugs that currently require users to pass 
options.

> Instead of letting individual driver to make decisions on which
> backlight interface this system should use(either in platform driver as
> we currently did, see acer-wmi and asus-wmi, or GPU driver as this case),
> I think we need a better and clear way to handle such things. For
> example, suppose an acer laptop: vendor does not support backlight, ACPI
> video's backlight interface is broken and GPU's works, to make it work,
> user will need to select acer-wmi module while this module does not have
> anything to do with the functionality, but simply because it serves as
> the backlight manager for acer laptops.

How do these machines work under Windows? Until we know the answer to 
that, we don't know what the correct way to handle the problem is under 
Linux.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
