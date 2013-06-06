Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3FFLIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:08:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42870 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932345Ab3FFLIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:08:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19GaVnZifz2HZIlxRNTCfyEBaV4DSmaf9E=
Date: Thu, 6 Jun 2013 07:08:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the imx-mxs
 tree
Message-ID: <20130606110806.GA23859@titan.lakedaemon.net>
References: <20130606153600.a23c3489dc8b30d0836cb8ea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606153600.a23c3489dc8b30d0836cb8ea@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:36:00PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mvebu tree got a conflict in
> arch/arm/Kconfig.debug between commit 284166ffebc3 ("ARM: imx: enable
> low-level debug support for imx6sl") from the imx-mxs tree and commit
> 5be22d8c29fd ("arm: mvebu: add another earlyprintk Kconfig option") from
> the mvebu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks Stephen!

thx,

Jason.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/Kconfig.debug
> index 29f7623,e6a6ab1..0000000
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@@ -639,9 -656,9 +664,10 @@@ config DEBUG_LL_INCLUD
>   				 DEBUG_IMX35_UART || \
>   				 DEBUG_IMX51_UART || \
>   				 DEBUG_IMX53_UART ||\
>  -				 DEBUG_IMX6Q_UART
>  +				 DEBUG_IMX6Q_UART || \
>  +				 DEBUG_IMX6SL_UART
> - 	default "debug/mvebu.S" if DEBUG_MVEBU_UART
> + 	default "debug/mvebu.S" if DEBUG_MVEBU_UART || \
> + 				   DEBUG_MVEBU_UART_ALTERNATE
>   	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
>   	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
>   	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART


