Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaIIIHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:07:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37272 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaIIIHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:07:51 -0400
Date: Tue, 9 Sep 2014 10:07:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Robert Richter <rric@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <rrichter@cavium.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Message-ID: <20140909080740.GP23009@pengutronix.de>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410176689-20020-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:44:48PM +0200, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Raising the current maximum limit to 64. This is needed for Cavium's
> Thunder systems that will have at least 48 cores per die.
> 
> The change keeps the current memory footprint in cpu mask structures.
> It does not break existing code. Setting the maximum to 64 cpus still
> boots systems with less cpus.
> 
> Mark's Juno happily booted with a NR_CPUS=64 kernel.
> 
> Tested on our Thunder system with 48 cores. We could see interrupts to
> all cores.
> 
> Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fd4e81a4e1ce..67fca2ea81a7 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -252,11 +252,11 @@ config SCHED_SMT
>  	  places. If unsure say N here.
>  
>  config NR_CPUS
> -	int "Maximum number of CPUs (2-32)"
> -	range 2 32
> +	int "Maximum number of CPUs (2-64)"
> +	range 2 64
>  	depends on SMP
>  	# These have to remain sorted largest to smallest
Unrelated to the patch: What does this comment mean? There is only one
line following, so it's sorted implicitly.

Best regards
Uwe

> -	default "8"
> +	default "64"

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
