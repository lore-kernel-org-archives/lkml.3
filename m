Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3GZHnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:43:42 -0400
Received: from know-smtprelay-omc-4.server.virginmedia.net ([80.0.253.68]:50592
	"EHLO know-smtprelay-omc-4.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3GZHnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:43:39 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=JuSpN7EC c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=Fov_KbFzXGIA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8
 a=FRpz2uVkEx4A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=1GhcjoaP9TfIvqN0zToA:9
 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=RT-k-radQS555kWI:21
 a=ubqhyRkJ84-5_2Wc:21 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1374824590.2254.3.camel@artifact>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Fri, 26 Jul 2013 08:43:10 +0100
In-Reply-To: <2218913.HKGjJcYT1G@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan> <2218913.HKGjJcYT1G@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 15:00 +0200, Rafael J. Wysocki wrote:
> On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > >
> > > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
> > > 
> > > Yes, but let's wait a while. Not because I think we'll fix the problem
> > > (hey, miracles might happen), but because I think it would be useful
> > > to couple the reverts with information about the particular machines
> > > that broke (and the people who reported it). So that when we
> > > inevitably try again, we can perhaps get some testing effort with
> > > those machines/people.
> > > 
> > > It doesn't seem to be a show-stopped for a large number of people, so
> > > there's no huge hurry. I'd suggest doing the revert just in time for
> > > rc3, but waiting until then to gather info about people who see
> > > breakage.
> > > 
> > > Sound like a plan?
> > 
> > Yes, it does.
> 
> OK, time to revert I guess.
> 
> James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> fixes the backlight for you.
> 
> Aaron, please double check if acpi_video_backlight_quirks() will still work as
> needed.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: Revert "ACPI / video / i915: No ACPI backlight if firmware expects Windows 8"
> 
> We attempted to address a regression introduced by commit a57f7f9
> (ACPICA: Add Windows8/Server2012 string for _OSI method.) after which
> ACPI video backlight support doesn't work on a number of systems,
> because the relevant AML methods in the ACPI tables in their BIOSes
> become useless after the BIOS has been told that the OS is compatible
> with Windows 8.  That problem is tracked by the bug entry at:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51231
> 
> Commit 8c5bd7a (ACPI / video / i915: No ACPI backlight if firmware
> expects Windows 8) introduced for this purpose essentially prevented
> the ACPI backlight support from being used if the BIOS had been told
> that the OS was compatible with Windows 8 and the i915 driver was
> loaded, in which case the backlight would always be handled by i915.
> Unfortunately, however, that turned out to cause problems with
> backlight to appear on multiple systems with symptoms indicating that
> i915 was unable to control the backlight on those systems as
> expected.
> 
> For this reason, revert commit 8c5bd7a, but leave the function
> acpi_video_backlight_quirks() introduced by it, because another
> commit on top of it uses that function.
> 
Works fine for me.

Tested-by: Steven Newbury <steve@snewbury.org.uk>

By the way, I'm willing to test any i915 backlight patches if it helps.

