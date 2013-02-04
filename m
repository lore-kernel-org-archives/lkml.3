Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3BDPy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:54:26 -0500
Received: from linux-sh.org ([111.68.239.195]:43859 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab3BDPyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:54:25 -0500
Date: Tue, 5 Feb 2013 00:53:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v8 2/4] misc: Generic on-chip SRAM allocation driver
Message-ID: <20130204155344.GA14171@linux-sh.org>
References: <1359977538-5859-1-git-send-email-p.zabel@pengutronix.de>
 <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 12:32:16PM +0100, Philipp Zabel wrote:
> This driver requests and remaps a memory region as configured in the
> device tree. It serves memory from this region via the genalloc API.
> It optionally enables the SRAM clock.
> 
> Other drivers can retrieve the genalloc pool from a phandle pointing
> to this drivers' device node in the device tree.
> 
> The allocation granularity is hard-coded to 32 bytes for now,
> to make the SRAM driver useful for the 6502 remoteproc driver.
> There is overhead for bigger SRAMs, where only a much coarser
> allocation granularity is needed: At 32 bytes minimum allocation
> size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>

How exactly is this "generic" if you have randomly hard-coded an
allocation granularity that is larger than half of the in-tree SRAM pool
users today can even support? Did you even bother to look at in-tree SRAM
pool users other than the one you are working on?

There also doesn't seem to be any real reason for the hard-coding either,
this information could easily be fetched via platform data or the device
tree, and the driver in question would simply need to be able to
determine whether the size is suitable for it or not.
