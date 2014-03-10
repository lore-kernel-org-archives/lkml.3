Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaCJOM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:12:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaCJOM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Peter Pearse <peter.pearse@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
Date: Mon, 10 Mar 2014 15:11:57 +0100
Message-ID: <5345792.VhzckVI5HA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394459790.2270.39.camel@shinybook.infradead.org>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20110101151545.GC25924@n2100.arm.linux.org.uk> <1394459790.2270.39.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:hF5i2NZVFL6Sy8tpsT1YkUDZev61yLUi2im8G+ZNeUc
 Ul1l/I5iN9Bk6pO+dyqTBQCjBs++oXv3oDLCVo4A+9y7M2YeKX
 Jsp7Ng9DR1ICUmWAmKBMYB4DFUXYbVjeNKPhqIgD8Ir3KNLaU6
 DqHOwzYz3tydPaYNiPH7qKSyLK8hyiLCbsuFZEJcwkq1A5pwBA
 Z77smOEsXrva3adIF4uH5xndonVQ+b/oBZsotPphUBRkcZ6cZ2
 3hsU6m9YQaZwlfHqN+479W0kgkUl03t+630OIZ4rC3WLbDUPUw
 trw3c1PkuHHngt6VstUA2LrQ9fsIjI8Z+4nfnSYT2U8Z1SI/M6
 VrA0+mlsMxH2b72WnD7M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 06:56:30 David Woodhouse wrote:
> It is not impossible for the DMA controller to "delegate" transactions
> so that (to the IOMMU) they appear to come from the individual slave
> device rather than from itself.
> 
> The Intel IOMMU has now gained support for DMA mapping for devices
> enumerated by ACPI — essentially the ACPI "DMAR" table just has a lookup
> table of ACPI device paths, and tells us the PCI bus/devfn that their
> DMA transactions will *appear* to be from.

This makes a lot of sense for standalone DMA masters enumerated by ACPI,
but I fail to see what the purpose of that would be when the DMA
is delegated to a separate DMA engine devices. Do you have an idea?

It sounds to me that they are trying to isolate the DMA masters
because the slave driver is not trusted for some reason, yet the
DMA engine driver that does the DMA is trusted.

> Of course, it's also possible that all these BIOSes are broken and they
> *should* just list the DMA controller itself, instead of all the slave
> devices. But while I'm always quick to jump to the conclusion that it's
> the BIOS at fault, that doesn't necessarily seem likely here...

It would be good to verify this anyway. There are multiple reasons why
we have to pass the dmaengine device to the dma-mapping API at the moment
rather than the slave device, but in essence it comes down to the engine
being the one that is the master on its parent bus. A trivial example
where it goes wrong would be the slave living on a 32-bit noncoherent bus
and the master living on a 64-bit coherent bus.

	Arnd
