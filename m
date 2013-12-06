Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3LFVFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:05:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47636 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3LFVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:05:39 -0500
Message-ID: <52A23BE0.2000207@ti.com>
Date: Sat, 7 Dec 2013 02:34:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH v3] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1386267092-18615-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1386267092-18615-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2013 11:41 PM, Ivan Khoronzhuk wrote:

> diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
> index 7aa105b..98a66ff 100644
> --- a/arch/arm/mach-davinci/board-mityomapl138.c
> +++ b/arch/arm/mach-davinci/board-mityomapl138.c
> @@ -432,6 +432,9 @@ static void __init mityomapl138_setup_nand(void)
>  {
>  	platform_add_devices(mityomapl138_devices,
>  				 ARRAY_SIZE(mityomapl138_devices));
> +
> +	if (davinci_aemif_setup(&mityomapl138_nandflash_device))
> +		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
>  }

I must be missing something, but exactly why is this required for
board-mityomapl138.c?

Thanks,
Sekhar
