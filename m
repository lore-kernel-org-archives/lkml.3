Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3K0AQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:16:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55006 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751106Ab3K0AQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:16:32 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        Lv Zheng <lv.zheng@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.
Date: Wed, 27 Nov 2013 01:29:20 +0100
Message-ID: <3542568.jpR4FU4Yha@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131126202905.GA12889@phenom.dumpdata.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <2011704.hD86fZ2Qk5@vostro.rjw.lan> <20131126202905.GA12889@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 03:29:05 PM Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 26, 2013 at 09:29:33PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 26, 2013 01:21:15 PM Lv Zheng wrote:
> > > Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> > > <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h> inclusions.
> > > 
> > > First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> > > should not be included directly from any files that are built for
> > > CONFIG_ACPI unset, because that generally leads to build warnings about
> > > undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> > > <linux/acpi.h> includes those files and for !CONFIG_ACPI it provides stub
> > > ACPI symbols to be used in that case.
> > > 
> > > Second, there are ordering dependencies between those files that always
> > > have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> > > prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> > > latter depends on are always there.  And <acpi/acpi.h> which provides
> > > basic ACPICA type declarations should always be included prior to any other
> > > ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> > > <linux/acpi.h> as appropriate.
> > > 
> > > This patch also includes necessary cleanups in the affected files where
> > > other ACPI headers is also included but not referenced.
> > >
> > 
> > This looks OK to me, but it touches several other subsystems.  It's better to
> > CC such things to linux-kernel at least.
> > 
> > Peter, Matthew, Tony, Konrad, Greg, Bjorn, do you have any objections against this?
> 
> CC-ing Boris and David here.
> 
> I presume the proper compilation tests to make sure they do compile properly
> has been done.

Yes and we're going to run it through the auto build machinery anyway.

Thanks,
Rafael

