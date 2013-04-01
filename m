Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3DAXM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:12:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49668 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759407Ab3DAXMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:12:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: Re: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
Date: Tue, 02 Apr 2013 01:20:27 +0200
Message-ID: <1676539.jiMCqtbGtq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <25773480.yrESpQY9Iv@vostro.rjw.lan>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <CAErSpo5iyziiGDKiy-416UQ2xr+2hvcHz6do+ueMmnPM5oy6Cw@mail.gmail.com> <25773480.yrESpQY9Iv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 01, 2013 11:24:37 PM Rafael J. Wysocki wrote:
> On Monday, April 01, 2013 02:53:12 PM Bjorn Helgaas wrote:
> > On Mon, Apr 1, 2013 at 2:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Monday, April 01, 2013 11:34:46 AM Bjorn Helgaas wrote:
> > >> [+cc Zheng, who added this with 71a83bd727]
> > >>
> > >> On Sat, Mar 30, 2013 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >> >
> > >> > The runtime PM of PCIe ports turns out to be quite fragile, as in
> > >> > some cases things work while in some other cases they don't and we
> > >> > don't seem to have a good way to determine whether or not they are
> > >> > going to work in advance.
> > >>
> > >> Do you have any references to problems encountered when enabling
> > >> runtime PM for PCIe ports?  That information will be useful to anybody
> > >> who wants to take another crack at getting this working.
> > >
> > > Well, bug 53811 is one example and problems recently reported by
> > > Martin are another.  Do you want me to dig deeper?
> > 
> > OK, I got this one:
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=53811
> > 
> > Martin has reported a lot of problems lately, and I don't know which
> > are related to runtime PM for PCIe ports.  I was hoping for a couple
> > URLs to put in the changelog so that when somebody gets the itch to
> > make this work, they have some useful info to start from.  If you
> > point me at a specific message, I'll dig up an archive URL for it.
> 
> This is the message in which Martin confirmed that the previous version of
> the $subject patch made insert/removal of devices into xHCI ports on his
> system work again.
> 
> > Otherwise, I'm afraid we'll just oscillate between "enable PM, find
> > bug, disable PM, enable PM, find same bug, disable PM, etc..."
> 
> That's a valid concern, but I think we have an idea about what kind of problems
> the runtime PM of PCIe ports may cause to happen (generally, PME and hotplug
> notifications may not work as expected).

I was thinking about this one in particular:

http://marc.info/?l=linux-acpi&m=136460903910718&w=2

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
