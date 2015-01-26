Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbbAZKgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:36:11 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:49784 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbbAZKgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:36:10 -0500
Date: Mon, 26 Jan 2015 11:36:05 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se
Message-ID: <20150126103605.GA20837@gradator.net>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <1422265139-23011-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422265139-23011-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v2 02/12] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,

On Mon, Jan 26, 2015 at 05:38:59PM +0800, Wenyou Yang wrote:
> From: Peter Rosin <peda@axentia.se>
> 
> The DDRSDR controller fails miserably to put LPDDR1 memories in
> self-refresh. Force the controller to think it has DDR2 memories
> during the self-refresh period, as the DDR2 self-refresh spec is
> equivalent to LPDDR1, and is correctly implemented in the
> controller.
> 
> Assume that the second controller has the same fault, but that is
> untested.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/pm_slowclock.S  |   43 +++++++++++++++++++++++++++++++-----
>  include/soc/at91/at91sam9_ddrsdr.h |    2 +-
>  2 files changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index e2bfaf5..1155217 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -100,6 +100,16 @@ ddr_sr_enable:
>  	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
>  	bne	sdr_sr_enable
>  
> +	/* LPDDR1 --> force DDR2 mode during self-refresh */

I think we should explain we are dealing with an errata here, this is 
not obvious at first sight, the patch summary may find its place here :-)

Sylvain
