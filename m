Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbbAXARb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:17:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63514 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752775AbbAXAR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:17:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH][v3] PCI / PM: Avoid resuming PCI devices during system suspend
Date: Sat, 24 Jan 2015 01:40:08 +0100
Message-ID: <1608158.mpjigghEOx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAErSpo6CFNBWp_CDZQc3XmCFzR5nEjWSfLSVG5c549pEHn4g4Q@mail.gmail.com>
References: <1460212.bInrzeZle0@vostro.rjw.lan> <20035664.sy5Q5n4bIK@vostro.rjw.lan> <CAErSpo6CFNBWp_CDZQc3XmCFzR5nEjWSfLSVG5c549pEHn4g4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2015 02:55:25 PM Bjorn Helgaas wrote:
> On Tue, Jan 20, 2015 at 7:17 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Commit f25c0ae2b4c4 (ACPI / PM: Avoid resuming devices in ACPI PM
> > domain during system suspend) modified the ACPI PM domain's system
> > suspend callbacks to allow devices attached to it to be left in the
> > runtime-suspended state during system suspend so as to optimize
> > the suspend process.
> >
> > This was based on the general mechanism introduced by commit
> > aae4518b3124 (PM / sleep: Mechanism to avoid resuming runtime-suspended
> > devices unnecessarily).
> >
> > Extend that approach to PCI devices by modifying the PCI bus type's
> > ->prepare callback to return 1 for devices that are runtime-suspended
> > when it is being executed and that are in a suitable power state and
> > need not be resumed going forward.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> I don't profess to understand this, and it seems like something you
> could merge via your PM tree.  So I trust you to do the right thing
> with it :)
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks!

