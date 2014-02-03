Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBCVgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:36:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57575 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752586AbaBCVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:36:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: Re: [PATCH v3 0/7] ACPI / hotplug / PCI: Consolidation of ACPIPHP with ACPI core device hotplug
Date: Mon, 03 Feb 2014 22:51:09 +0100
Message-ID: <3208910.EcIUVqxZdQ@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140203104511.GR18029@intel.com>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <5157096.hCmU2aoKCT@vostro.rjw.lan> <20140203104511.GR18029@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 03, 2014 12:45:11 PM Mika Westerberg wrote:
> On Sun, Feb 02, 2014 at 06:11:19PM +0100, Rafael J. Wysocki wrote:
> > As stated in the message at http://marc.info/?l=linux-acpi&m=139135963030012&w=4 ,
> > patch [1/6] was actaully wrong and the whole patchset had to be reworked for that
> > reason.  What follows is an entirely new version:
> > 
> > [1/7] Add a new function to ACPICA allowing a callback to be executed under the
> >       namespace mutex after calling acpi_ns_get_attached_data().
> > 
> > [2/7] Use the new ACPICA's function to fix a couple of potential races related
> >       to ACPI notifies.
> > 
> > [3/7] Same as [2/6] above.
> > [4/7] Same as [3/6] above, rebased.
> > [5/7] Same as [4/6] above.
> > [6/7] Same as [5/6] above.
> > [7/7] Dispatch ACPI hotplug notifications for "core" devices and PCI from
> >       acpi_bus_notify().  This actually is different from [6/6] above, although
> >       it serves the same purpose.
> > 
> 
> On Intel NUC and DZ77RE-75K,
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks a lot for testing!

In the meantime, though, I found two more race conditions in ACPIPHP related to
races with sysfs-triggered device remove.  I have patches to fix them, but then
I had to rebase this series (and the ACPIPHP one this is based on) on top of
those fixes.

I'm going to resend the two patchsets as one series including the fixes
mentioned above.  I tried to avoid sending out a series of 20+ patches, because
then it's almost guaranteed that no one will look at them unless they happen to
break things in testing, but I guess I have no choice but to do that at this
point.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
