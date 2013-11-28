Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab3K1OGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:06:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62367 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751213Ab3K1OGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:06:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.
Date: Thu, 28 Nov 2013 15:18:54 +0100
Message-ID: <77005542.rPYLivMWph@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2011704.hD86fZ2Qk5@vostro.rjw.lan>
References: <cover.1385094640.git.lv.zheng@intel.com> <3c5e408cd7791ef746f462c79ce28f67734817d9.1385434808.git.lv.zheng@intel.com> <2011704.hD86fZ2Qk5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 09:29:33 PM Rafael J. Wysocki wrote:
> On Tuesday, November 26, 2013 01:21:15 PM Lv Zheng wrote:
> > Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> > <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h> inclusions.
> > 
> > First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> > should not be included directly from any files that are built for
> > CONFIG_ACPI unset, because that generally leads to build warnings about
> > undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> > <linux/acpi.h> includes those files and for !CONFIG_ACPI it provides stub
> > ACPI symbols to be used in that case.
> > 
> > Second, there are ordering dependencies between those files that always
> > have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> > prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> > latter depends on are always there.  And <acpi/acpi.h> which provides
> > basic ACPICA type declarations should always be included prior to any other
> > ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> > <linux/acpi.h> as appropriate.
> > 
> > This patch also includes necessary cleanups in the affected files where
> > other ACPI headers is also included but not referenced.
> >
> 
> This looks OK to me, but it touches several other subsystems.  It's better to
> CC such things to linux-kernel at least.
> 
> Peter, Matthew, Tony, Konrad, Greg, Bjorn, do you have any objections against this?

Since no one seems to have problems with this, I've queued it up for the next ACPI
pull request, if there are no problems with auto builds.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
