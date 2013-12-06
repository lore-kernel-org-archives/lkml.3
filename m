Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3LFOhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:37:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17423 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab3LFOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:36:58 -0500
Date: Fri, 6 Dec 2013 09:31:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 2/6] ACPI: Clean up inclusions of ACPI header files
Message-ID: <20131206143142.GF3096@pegasus.dumpdata.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <cover.1386316208.git.lv.zheng@intel.com>
 <4e8fb7987f7d0390a2e74622c7c1cbb6760c6516.1386317357.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8fb7987f7d0390a2e74622c7c1cbb6760c6516.1386317357.git.lv.zheng@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 04:51:52PM +0800, Lv Zheng wrote:
> Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h>
> inclusions and remove some inclusions of those files that aren't
> necessary.
> 
> First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> should not be included directly from any files that are built for
> CONFIG_ACPI unset, because that generally leads to build warnings about
> undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> <linux/acpi.h> includes those files and for CONFIG_ACPI unset it
> provides stub ACPI symbols to be used in that case.
> 
> Second, there are ordering dependencies between those files that always
> have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> latter depends on are always there.  And <acpi/acpi.h> which provides
> basic ACPICA type declarations should always be included prior to any other
> ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> <linux/acpi.h> as appropriate.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (drivers/pci stuff)
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

.. for the Xen stuff with the assertion that you did build with the
right CONFIG_XEN...=y parameters).

Thank you!
