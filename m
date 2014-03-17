Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbaCQOeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:34:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbaCQOeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:34:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH2] CNS3xxx: Fix a WARN() related to IRQ allocation.
Date: Mon, 17 Mar 2014 15:33:49 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Krzysztof =?utf-8?q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton@enomsg.org>, Yinghai Lu <yinghai@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m338iynsp0.fsf@t19.piap.pl>
In-Reply-To: <m338iynsp0.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201403171533.50200.arnd@arndb.de>
X-Provags-ID: V02:K0:J6lnhUOamfjkaq0z+l2KGGWKVwchCJosifKZbCsR6M9
 iv8IMsMjgAfVMD59Uv/CiDAkAov1bp0Z5ovYxStG0LsWgxUC2d
 jPfR9gcDla76Yke3CERqYlF7bmVe78z3LTd7g9aL7r8AkdCTvT
 UG0nHm5evsxiGzZPSdzO7pKZz2PqDFZF+wxybZqhxkzlB8zRE4
 EvlvpqHx52IS63jH1or5osXynokeXshAvoeUiGkZaqoc/QtuUJ
 rixyUUeQW/NdbyunEsC37YNbzx4JFN1X/oFBzCZ1LDwcn1G/RL
 frXuXqW2ARlICZW//81nm6OsTVCTsFgoVsGBik5yXTKcFoVj81
 rDjqQ0elEvdFE9OCJExcBJUY75ocB7ReJdXjH/rXw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014, Krzysztof Hałasa wrote:
> WARNING: at drivers/irqchip/irq-gic.c:952 gic_init_bases+0xe4/0x2b8()
> Cannot allocate irq_descs @ IRQ16, assuming pre-allocated
> Backtrace:
> gic_init_bases    from cns3xxx_init_irq+0x24/0x34
> cns3xxx_init_irq  from init_IRQ+0x24/0x2c
> init_IRQ          from start_kernel+0x1a8/0x338
> start_kernel      from 0x2000806c
> 
> The problem is that 64 CNS3xxx CPU interrupts, starting at 32, are
> allocated by the ARM platform-independent code (as requested by
> machine_desc->nr_irqs = 96), and then the GIC code tries to allocate
> them again.
> 
> Tested on Gateworks Laguna board, masqueraded as CNS3420VB.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

Applied to next/fixes-non-critical.

	Arnd

> --- a/arch/arm/mach-cns3xxx/cns3420vb.c
> +++ b/arch/arm/mach-cns3xxx/cns3420vb.c
> @@ -246,7 +246,6 @@ static void __init cns3420_map_io(void)
>  
>  MACHINE_START(CNS3420VB, "Cavium Networks CNS3420 Validation Board")
>         .atag_offset    = 0x100,
> -       .nr_irqs        = NR_IRQS_CNS3XXX,
>         .map_io         = cns3420_map_io,
>         .init_irq       = cns3xxx_init_irq,
>         .init_time      = cns3xxx_timer_init,
> --- a/arch/arm/mach-cns3xxx/core.c
> +++ b/arch/arm/mach-cns3xxx/core.c
> @@ -400,7 +400,6 @@ static const char *cns3xxx_dt_compat[] __initdata = {
>  
>  DT_MACHINE_START(CNS3XXX_DT, "Cavium Networks CNS3xxx")
>         .dt_compat      = cns3xxx_dt_compat,
> -       .nr_irqs        = NR_IRQS_CNS3XXX,
>         .map_io         = cns3xxx_map_io,
>         .init_irq       = cns3xxx_init_irq,
>         .init_time      = cns3xxx_timer_init,

