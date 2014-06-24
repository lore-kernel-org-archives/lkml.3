Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaFXPoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:44:13 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:44191 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaFXPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:44:10 -0400
Date: Tue, 24 Jun 2014 11:44:07 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v6 1/4] arm: fiq: Add callbacks to manage FIQ routings
In-Reply-To: <1403623097-1153-2-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.LFD.2.11.1406241138450.16842@knanqh.ubzr>
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-2-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Daniel Thompson wrote:

> Currently enable_fiq/disable_fiq use a simple offset to convert an IRQ
> virq into a FIQ virq. This is too inflexible for multi-platform kernels
> and makes runtime error checking impossible.
> 
> We solve this by introducing a flexible mapping that allows interrupt
> controllers that support FIQ to register those mappings. This, in turn,
> makes it much possible for drivers in DT kernels to install FIQ handlers
> without knowing anything about the interrupt controller.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/arm/include/asm/fiq.h |   7 +++
>  arch/arm/kernel/fiq.c      | 103 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 108 insertions(+), 2 deletions(-)

[...]

> +bool has_fiq(int fiq)
> +{
> +	struct fiq_data *data = lookup_fiq_data(fiq);
> +
> +	if (data)
> +		return true;
> +
> +	if (fiq_start == -1)
> +		return false;
> +
> +	return fiq > fiq_start;

Shouldn't this be fiq >= fiq_start ?

Other than that...

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
