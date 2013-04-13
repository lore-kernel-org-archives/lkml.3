Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3DMM7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 08:59:16 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:53943 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab3DMM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <1365651463-11502-3-git-send-email-zhangwm@marvell.com>
References: <1365651463-11502-1-git-send-email-zhangwm@marvell.com>
	<1365651463-11502-3-git-send-email-zhangwm@marvell.com>
Date: Sat, 13 Apr 2013 20:59:13 +0800
Message-ID: <CAN1soZyibQLOkeeZAi-8kWVJtgS9z9g0kyVSGunP-QO4dEkuzg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: mmp: move function declaration to head file
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:37 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> Move some of the function declaration to head file.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  arch/arm/mach-mmp/common.h  |    3 +++
>  arch/arm/mach-mmp/mmp-dt.c  |    3 ---
>  arch/arm/mach-mmp/mmp2-dt.c |    3 ---
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
> index 0bdc50b..8c9b510 100644
> --- a/arch/arm/mach-mmp/common.h
> +++ b/arch/arm/mach-mmp/common.h
> @@ -8,3 +8,6 @@ extern void mmp_restart(char, const char *);
>  extern void __init pxa168_clk_init(void);
>  extern void __init pxa910_clk_init(void);
>  extern void __init mmp2_clk_init(void);
> +
> +extern void __init mmp_dt_irq_init(void);
> +extern void __init mmp_dt_init_timer(void);

It's better to make use of of_irq_init() & CLOCKSOURCE_OF_DECLARE()
for timer. So I'll move mmp timer into clocksource & mmp irq into
irqchip directory in the next week. You can rebase your code. Is it OK?

> diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
> index d063efa..af0bb5b 100644
> --- a/arch/arm/mach-mmp/mmp-dt.c
> +++ b/arch/arm/mach-mmp/mmp-dt.c
> @@ -19,9 +19,6 @@
>
>  #include "common.h"
>
> -extern void __init mmp_dt_irq_init(void);
> -extern void __init mmp_dt_init_timer(void);
> -
>  static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
>         OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
>         OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
> diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
> index fad431a..4ba1fbe 100644
> --- a/arch/arm/mach-mmp/mmp2-dt.c
> +++ b/arch/arm/mach-mmp/mmp2-dt.c
> @@ -21,9 +21,6 @@
>
>  #include "common.h"
>
> -extern void __init mmp_dt_irq_init(void);
> -extern void __init mmp_dt_init_timer(void);
> -
>  static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
>         OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
>         OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
> --
> 1.7.4.1
>
