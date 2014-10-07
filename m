Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaJGW7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:59:08 -0400
Received: from ozlabs.org ([103.22.144.67]:33576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaJGW7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:59:06 -0400
In-Reply-To: <1412678902-18672-9-git-send-email-mikey@neuling.org>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        benh@kernel.crashing.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: cbe-oss-dev@lists.ozlabs.org, mikey@neuling.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [v3, 08/16] powerpc/powerpc: Add new PCIe functions for allocating cxl interrupts
Message-Id: <20141007225905.0F85514011E@ozlabs.org>
Date: Wed,  8 Oct 2014 09:59:04 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-10 at 10:48:14 UTC, Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This adds a number of functions for allocating IRQs under powernv PCIe for cxl.
> 
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index baf3de6..3b67010b 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -38,6 +38,8 @@
>  #include <asm/debug.h>
>  #include <asm/firmware.h>
>  
> +#include <misc/cxl.h>

You should be including pnv-pci.h here.

Otherwise the header and the implementation could get out of sync, it will also
fix these:

  arch/powerpc/platforms/powernv/pci-ioda.c:1365:5: warning: symbol 'pnv_phb_to_cxl' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1389:5: warning: symbol 'pnv_cxl_alloc_hwirqs' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1404:6: warning: symbol 'pnv_cxl_release_hwirqs' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1413:6: warning: symbol 'pnv_cxl_release_hwirq_ranges' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1433:5: warning: symbol 'pnv_cxl_alloc_hwirq_ranges' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1470:5: warning: symbol 'pnv_cxl_get_irq_count' was not declared. Should it be static?
  arch/powerpc/platforms/powernv/pci-ioda.c:1479:5: warning: symbol 'pnv_cxl_ioda_msi_setup' was not declared. Should it be static?

cheers
