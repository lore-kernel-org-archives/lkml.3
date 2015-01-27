Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbbA0KIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:08:34 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:41463 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbbA0KI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:08:29 -0500
Date: Tue, 27 Jan 2015 11:08:24 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se,
        sergei.shtylyov@cogentembedded.com, linux@maxim.org.za
Message-ID: <20150127100824.GC32121@gradator.net>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338300-5984-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422338300-5984-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v3 08/13] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,

On Tue, Jan 27, 2015 at 01:58:20PM +0800, Wenyou Yang wrote:
> 
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 0377c0d..d967c31 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -71,7 +71,7 @@ static int at91_pm_begin(suspend_state_t state)
>   * Verify that all the clocks are correct before entering
>   * slow-clock mode.
>   */
> -static int at91_pm_verify_clocks(void)
> +static int at91_pm_verify_clocks(suspend_state_t state)
>  {
>  	unsigned long scsr;
>  	int i;
> @@ (...)

Unused state argument, it was added in v2, this is just a trace of a 
reverted v2 change not fully cleaned.


> +		if (!at91_pm_verify_clocks(state))
> +			goto error;

Ditto.


Sylvain
