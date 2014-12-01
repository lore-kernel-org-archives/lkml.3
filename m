Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaLALzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:55:23 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:49583 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbaLALzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:55:21 -0500
Message-ID: <1417434919.30245.31.camel@x220>
Subject: Re: [PATCH 3/4] ARM: at91: remove at91sam9260/at91sam9g20 legacy
 board support
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Date: Mon, 01 Dec 2014 12:55:19 +0100
In-Reply-To: <4ea21d8c3309cde82c88eb6624cf2aaf08cb8bca.1416392687.git.nicolas.ferre@atmel.com>
References: <cover.1416392687.git.nicolas.ferre@atmel.com>
	 <4ea21d8c3309cde82c88eb6624cf2aaf08cb8bca.1416392687.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2014 11:55:19.0556 (UTC) FILETIME=[ADF7C440:01D00D5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 11:31 +0100, Nicolas Ferre wrote:
> Second part of at91sam9260/at91sam9g20 legacy !DT removal. This is the core !DT
> support removal for these two Atmel SoCs.
> Use the Device Tree for running this board with newer kernels.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

There might be a problem with this patch. Or maybe it only needs some
follow up cleanup. I noticed that when it landed in today's linux-next
(ie, next-20141201) as commit b2026f708e09 ("ARM: at91: remove
at91sam9260/at91sam9g20 legacy board support").

>  arch/arm/configs/at91sam9260_9g20_defconfig |  145 ---
>  arch/arm/mach-at91/Kconfig.non_dt           |  117 ---
>  arch/arm/mach-at91/Makefile                 |    1 -
>  arch/arm/mach-at91/at91sam9260.c            |  397 --------
>  arch/arm/mach-at91/at91sam9260_devices.c    | 1364 ---------------------------
>  5 files changed, 2024 deletions(-)
>  delete mode 100644 arch/arm/configs/at91sam9260_9g20_defconfig
>  delete mode 100644 arch/arm/mach-at91/at91sam9260_devices.c
> 
>[...]
> diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
> index a9458234ab23..079772047541 100644
> --- a/arch/arm/mach-at91/Kconfig.non_dt
> +++ b/arch/arm/mach-at91/Kconfig.non_dt
>[...]
> @@ -123,113 +113,6 @@ endif
>  
>  # ----------------------------------------------------------
>  
> -if ARCH_AT91SAM9260
> -
> -comment "AT91SAM9260 Variants"
> -
> -comment "AT91SAM9260 / AT91SAM9XE Board Type"
> -
> -config MACH_AT91SAM9260EK
> -	bool "Atmel AT91SAM9260-EK / AT91SAM9XE Evaluation Kit"
> -	select HAVE_AT91_DATAFLASH_CARD
> -	help
> -	  Select this if you are using Atmel's AT91SAM9260-EK or AT91SAM9XE Evaluation Kit
> -	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3933>
> -
> -config MACH_CAM60
> -	bool "KwikByte KB9260 (CAM60) board"
> -	help
> -	  Select this if you are using KwikByte's KB9260 (CAM60) board based on the Atmel AT91SAM9260.
> -	  <http://www.kwikbyte.com/KB9260.html>
> -
> -config MACH_SAM9_L9260
> -	bool "Olimex SAM9-L9260 board"
> -	select HAVE_AT91_DATAFLASH_CARD
> -	help
> -	  Select this if you are using Olimex's SAM9-L9260 board based on the Atmel AT91SAM9260.
> -	  <http://www.olimex.com/dev/sam9-L9260.html>
> -
> -config MACH_AFEB9260
> -	bool "Custom afeb9260 board v1"
> -	help
> -	  Select this if you are using custom afeb9260 board based on
> -	  open hardware design. Select this for revision 1 of the board.
> -	  <svn://194.85.238.22/home/users/george/svn/arm9eb>
> -	  <http://groups.google.com/group/arm9fpga-evolution-board>

The Kconfig symbol SND_AT91_SOC_AFEB9260 (see sound/soc/atmel/Kconfig)
still depends on MACH_AFEB9260. So it can't be set anymore. Is that
Kconfig symbol still needed or should it be removed too? Maybe a patch
that fixes that is queued somewhere already.


Paul Bolle

