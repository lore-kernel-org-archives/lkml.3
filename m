Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaDAFe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:34:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaDAFe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:34:26 -0400
Date: Tue, 1 Apr 2014 07:33:43 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: tthayer@altera.com
Cc: dinguyen@altera.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, devicetree@hellion.org.uk, galak@codeaurora.org,
        rob@landley.net, linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: socfpga: Add support for Altera SoC SDRAM
 controller
Message-ID: <20140401053343.GO5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
 <1396303627-29198-3-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396303627-29198-3-git-send-email-tthayer@altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:28:27 up 219 days, 14:59, 49 users,  load average: 0,04, 0,06,
 0,09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 05:07:07PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the Altera SDRAM controller registers to the
> Altera SoC project. These registers are shared by future
> drivers such as ECC and the FPGA bridge.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> To: Rob Herring <rob.herring@calxeda.com>
> To: Pawel Moll <pawel.moll@arm.com>
> To: Mark Rutland <mark.rutland@arm.com>
> To: Ian Campbell <ijc+devicetree@hellion.org.uk>
> To: Kumar Gala <galak@codeaurora.org>
> To: Rob Landley <rob@landley.net>
> To: Russell King <linux@arm.linux.org.uk>
> To: Dinh Nguyen <dinguyen@altera.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/mach-socfpga/socfpga.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
> index 21d6026..d514e8a 100644
> --- a/arch/arm/mach-socfpga/socfpga.c
> +++ b/arch/arm/mach-socfpga/socfpga.c
> @@ -32,6 +32,7 @@
>  void __iomem *socfpga_scu_base_addr = ((void __iomem *)(SOCFPGA_SCU_VIRT_BASE));
>  void __iomem *sys_manager_base_addr;
>  void __iomem *rst_manager_base_addr;
> +void __iomem *sdr_ctl_base_addr;
>  void __iomem *clk_mgr_base_addr;
>  unsigned long cpu1start_addr;
>  

Can't we get rid of all these global pointers instead of adding to them?

> @@ -150,6 +151,15 @@ void __init socfpga_sysmgr_init(void)
>  
>  	np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
>  	clk_mgr_base_addr = of_iomap(np, 0);
> +
> +	np = of_find_compatible_node(NULL, NULL, "altr,sdr-ctl");
> +	if (!np) {
> +		pr_err("SOCFPGA: Unable to find sdr-ctl\n");
> +		return;
> +	}
> +
> +	sdr_ctl_base_addr = of_iomap(np, 0);
> +	WARN_ON(!sdr_ctl_base_addr);
>  }
>  
>  static void __init socfpga_init_irq(void)
> -- 
> 1.7.9.5
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
