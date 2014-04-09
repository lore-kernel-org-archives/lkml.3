Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbaDILc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:32:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35688 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaDILcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:32:53 -0400
Date: Wed, 9 Apr 2014 13:32:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: dougthompson@xmission.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, punnaia@xilinx.com
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
Message-ID: <20140409113246.GA8778@pd.tnic>
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
 <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 08:02:40PM +0530, Punnaiah Choudary Kalluri wrote:
> Add support for ARM Pl310 L2 cache controller parity error
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
>  .../devicetree/bindings/edac/pl310_edac_l2.txt     |   19 ++
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/pl310_edac_l2.c                       |  236 ++++++++++++++++++++
>  4 files changed, 263 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
>  create mode 100644 drivers/edac/pl310_edac_l2.c
> 
> diff --git a/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
> new file mode 100644
> index 0000000..94fbb8d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
> @@ -0,0 +1,19 @@
> +Pl310 L2 Cache EDAC driver, it does reports the data and tag ram parity errors.
> +
> +Required properties:
> +- compatible: Should be "arm,pl310-cache".
> +- intterupts: Interrupt number to the cpu.
> +- reg: Physical base address and size of cache controller's memory mapped
> +  registers
> +
> +Example:
> +++++++++
> +
> +	L2: cache-controller {
> +		compatible = "arm,pl310-cache";
> +		interrupts = <0 2 4>;
> +		reg = <0xf8f02000 0x1000>;
> +	};
> +
> +PL310 L2 Cache EDAC driver detects the Parity enable state by reading the
> +appropriate control register.
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..059ac31 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -326,6 +326,13 @@ config EDAC_TILE
>  	  Support for error detection and correction on the
>  	  Tilera memory controller.
>  
> +config EDAC_PL310_L2
> +	tristate "Pl310 L2 Cache Controller"
> +	depends on EDAC_MM_EDAC && ARM
> +	help
> +	  Support for parity error detection on L2 cache controller
> +	  data and tag ram memory
> +


Ok, so I'm looking at this after having looked at the synopsys thing
and it looks very similar in functionality - it does the basic dance of
registering and setting up stuff, only using different devicetree nodes,
regs, etc.

However, it adds a new file under drivers/edac/ and I'm wondering if it
wouldn't be better to simply create a xilinx_edac.c and put all your
stuff in there, maybe even share code by abstracting it nicely. Having
a separate driver only for a single L2 cache controller seems kinda too
granulary for me.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
