Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJPHfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:35:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:22013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaJPHfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,730,1406617200"; 
   d="scan'208";a="615370618"
Date: Thu, 16 Oct 2014 12:29:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Ray Jui <rjui@broadcom.com>
Cc: Dan Williams <djbw@fb.com>, Scott Branden <sbranden@broadcom.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Consider moving the init of pl330 to earlier?
Message-ID: <20141016065912.GB1638@intel.com>
References: <5436FF8F.8060602@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5436FF8F.8060602@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 02:35:11PM -0700, Ray Jui wrote:
> Hi,
> 
> How do you guys like the idea of moving the driver initialization of
> the pl330 DMA driver to earlier? For example, to arch_initcall_sync
> or subsys_initcall? Currently the pl330 driver is registered through
> module_amba_driver call, which translates to device_initcall in the
> end. This is a bit late considering in many systems, DMA controller
> is one of the core components that may have many slave devices
> depending on. Most slave drivers are typically done at
> device_initcall. When done at the same level, DMA may not be ready
> while the slave devices are being initialized. In addition, under
> the drivers/dma directory, we currently have various other DMA
> drivers also done at subsys_initcall.
> 
> One issue that I'm seeing with the Broadcom Cygnus SoC is that, when
> we try to use DMA with SPI (PL022), the request for DMA channel
> would fail because the spi-pl022 driver we use is initialized at
> subsys_initcall. At the time the PL330 driver is not yet
> initialized. The reason why spi-pl022 is done at subsys_initcall is
> that some regulators communicate through the SPI bus so people
> decided to move it to earlier (commit 25c8e03b by Linus Walleij),
> which seems to be a valid reason to me.
As a subsytem we encourage folks to use early init calls and then have
clients use late_init so that dependency is solved.

So feel free to send the patch

-- 
~Vinod

