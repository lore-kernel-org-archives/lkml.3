Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaBEIdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:33:21 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:35065 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBEIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:33:20 -0500
Message-ID: <52F1F74C.2090106@codethink.co.uk>
Date: Wed, 05 Feb 2014 08:33:16 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-pci@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, valentine.barshak@cogentembedded.com,
        horms@verge.net.au, bhelgaas@google.com
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space
 update
References: <20140205065243.29445.76593.sendpatchset@w520>
In-Reply-To: <20140205065243.29445.76593.sendpatchset@w520>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 06:52, Magnus Damm wrote:
> PCI: rcar: Driver model and physical address space update
>
> [PATCH 01/04] PCI: rcar: Register each instance independently
> [PATCH 02/04] PCI: rcar: Break out window size handling
> [PATCH 03/04] PCI: rcar: Add DMABOUNCE support
> [PATCH 04/04] PCI: rcar: Enable BOUNCE in case of HIGHMEM
>
> These patches update the pci-rcar-gen2.c driver in various ways
> including cleanups for driver model interface (1/4), readability
> update (2/4) and also bounce buffer support (3/4, 4/4). Basically
> the first two are just cleanups and the rest are fixes.
>
> As it is today without these patches the system memory start address
> is hard coded at 0x4000000 and the window is fixed at 1GiB. So we
> have board specific code hidden in the driver which is good to avoid.
>
> With these hard coded board specific constants there are some error cases
> that are not handled, in particular the issue that only maximum 1GiB of
> physical address space can be used for bus mastering with a single window.
> The common case of using ARM CONFIG_VMSPLIT_3G results in no visible issues
> as long as CONFIG_BOUNCE is used, but other CONFIG_VMSPLIT settings will
> break due to the hard coded 1GiB window not being enough. It has been
> verified that reducing the window size to 256MB makes the driver behave
> the same with VMSPLIT_3G as 1GiB window size and other VMSPLIT settings.
>
> To handle the maximum 1GiB physical address space limitation two types
> of bounce buffers are added. The ARM specific DMABOUNCE code is in 3/4
> hooked up to a chunk of local memory that is also handed of as coherent
> memory to the pci devices hanging off the PCI bridge. The driver makes
> sure to set the window so the local memory is always included. When the
> PCI devices are operating and in case memory is used outside the window
> then the DMABOUNCE buffers kicks in. This makes the driver support all
> kinds of VMSPLIT settings and window sizes. The BOUNCE code in 4/4 is
> selected to make sure bounce buffers are used for HIGHMEM.
>
> With these patches this driver can be used with or without CMA and
> with or without DMA zone. Basically the system wide memory setup is
> left to the user. If a DMA zone is used then the PCI window will
> be setup to cover that. Same thing with CMA.
>
> Tested with USB storage using LPAE and various VMSPLIT settings together
> with renesas git tag renesas-devel-v3.14-rc1-20140204 from kernel.org

Ok, is it possible to build a set with my of updates ready for next
merge window? I can update the set based on this if you like and try
and make the necessary changes to deal with the modifications from this
series.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
