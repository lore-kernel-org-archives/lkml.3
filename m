Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3FCNYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:24:03 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:59197 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3FCNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:24:01 -0400
Date: Mon, 3 Jun 2013 09:23:58 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH] drivers/bus: arm-cci: fix combined ARMv6+v7 build
In-Reply-To: <2485806.Uv8bUctxav@wuerfel>
Message-ID: <alpine.LFD.2.03.1306030922380.1200@syhkavp.arg>
References: <2485806.Uv8bUctxav@wuerfel>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Arnd Bergmann wrote:

> When we build a kernel with support for both ARMv6 and ARMv7,
> gas is trying to be helpful by pointing out that the arm-cci
> driver would not work on ARMv6:
> 
> /tmp/ccu1LDeU.s: Assembler messages:
> /tmp/ccu1LDeU.s:450: Error: selected processor does not support ARM mode `wfi '
> /tmp/ccu1LDeU.s:451: Error: selected processor does not support ARM mode `wfe '
> make[4]: *** [drivers/bus/arm-cci.o] Error 1
> 
> We know that the driver will only be used on ARMv7, hence we
> can annotate the inline assembly listing to allow those instructions.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Dave Martin <dave.martin@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

Since this code is merged into ARM-SOC, I assume you'll take care of 
this patch?


> 
> diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
> index 380319e..7332889 100644
> --- a/drivers/bus/arm-cci.c
> +++ b/drivers/bus/arm-cci.c
> @@ -253,7 +253,7 @@ EXPORT_SYMBOL_GPL(cci_disable_port_by_cpu);
>  asmlinkage void __naked cci_enable_port_for_self(void)
>  {
>  	asm volatile ("\n"
> -
> +"	.arch armv7-a\n"
>  "	mrc	p15, 0, r0, c0, c0, 5	@ get MPIDR value \n"
>  "	and	r0, r0, #"__stringify(MPIDR_HWID_BITMASK)" \n"
>  "	adr	r1, 5f \n"
> 
