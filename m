Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaE1Q7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:59:07 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37334 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaE1Q7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:59:03 -0400
Date: Wed, 28 May 2014 10:58:56 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: pci: add call to pcie_bus_configure_settings()
Message-ID: <20140528165856.GA20193@obsidianresearch.com>
References: <1401287176-4986-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401287176-4986-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:26:16AM -0400, Murali Karicheri wrote:
> PCI core supports PCIE_BUS_SAFE and PCIE_BUS_PERFORMANCE modes.
> PCI controllers may not be able to handle pay load size higher
> than MPS and also read data size higher than MRSS. So limit the
> max to the least common supported payload size by calling
> pcie_bus_configure_settings(). Using pci=pcie_bus_safe do a walk
> and set the MPS to least common value used by devices on the bus.
> pci=pcie_bus_perf does do a walk and set MRSS to MPS.

This text doesn't make much sense.. Calling
pcie_bus_configure_settings is just a good thing to do, the fact it
helps avoid a HW defect in a specific PCI-E implementation is not the
main reason to add this to the core ARM code.

 Call pcie_bus_configure_settings on ARM, like for other
 platforms. pcie_bus_configure_settings makes sure the MPS across the
 bus is uniform and provides the ability to tune the MRSS and MPS to
 higher performance values.

 This is particularly important for embedded where there is no
 firmware to program these PCI-E settings for the OS.

> +
> +			list_for_each_entry(child, &bus->children, node)
> +			pcie_bus_configure_settings(child);
                  ^^^^^^^^^^^^^^^

Missing indent.

Regards,
Jason
