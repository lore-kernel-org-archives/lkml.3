Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaAMJ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:28:32 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64348 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaAMJ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:28:29 -0500
MIME-Version: 1.0
In-Reply-To: <1389367095-7760-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1389367095-7760-1-git-send-email-ben.dooks@codethink.co.uk>
Date: Mon, 13 Jan 2014 10:28:29 +0100
X-Google-Sender-Auth: 2fMsDyUfpQH0AyOObhvmfr9ZAbI
Message-ID: <CAMuHMdU+SfjNJC_b_7ovT9Uf5p5MwB0iULjorzthcLJxYJ-00g@mail.gmail.com>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 4:18 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> --- a/drivers/sh/Makefile
> +++ b/drivers/sh/Makefile
> @@ -3,7 +3,10 @@
>  #
>  obj-y  := intc/
>
> +ifeq ($(CONFIG_COMMON_CLK),n)
>  obj-$(CONFIG_HAVE_CLK)         += clk/
> +endif
> +

This part breaks my Koelsch legacy (non-reference) build:

arch/arm/kernel/built-in.o: In function `twd_local_timer_common_register':
io.c:(.init.text+0x1804): undefined reference to `clk_enable'
io.c:(.init.text+0x1828): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `sci_port_disable':
clkdev.c:(.text+0x2ae30): undefined reference to `clk_disable'
clkdev.c:(.text+0x2ae38): undefined reference to `clk_disable'
drivers/built-in.o: In function `sci_port_enable':
clkdev.c:(.text+0x2ae74): undefined reference to `clk_enable'
clkdev.c:(.text+0x2ae7c): undefined reference to `clk_get_rate'
clkdev.c:(.text+0x2ae88): undefined reference to `clk_enable'
drivers/built-in.o: In function `sci_notifier':
clkdev.c:(.text+0x2c85c): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `__pm_clk_remove':
clkdev.c:(.text+0x40844): undefined reference to `clk_disable'
drivers/built-in.o: In function `pm_clk_suspend':
clkdev.c:(.text+0x40c6c): undefined reference to `clk_disable'
drivers/built-in.o: In function `pm_clk_resume':
clkdev.c:(.text+0x40ce0): undefined reference to `clk_enable'
drivers/built-in.o: In function `qspi_set_config_register':
clkdev.c:(.text+0x515a4): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `rspi_set_config_register':
clkdev.c:(.text+0x516dc): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `rspi_remove':
clkdev.c:(.text+0x518ac): undefined reference to `clk_disable'
drivers/built-in.o: In function `rspi_probe':
clkdev.c:(.text+0x51a20): undefined reference to `clk_enable'
clkdev.c:(.text+0x51d60): undefined reference to `clk_disable'
drivers/built-in.o: In function `hspi_transfer_one_message':
clkdev.c:(.text+0x5312c): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `sh_msiof_spi_txrx':
clkdev.c:(.text+0x53d90): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `sh_msiof_spi_chipselect':
clkdev.c:(.text+0x54200): undefined reference to `clk_enable'
clkdev.c:(.text+0x542b8): undefined reference to `clk_disable'
drivers/built-in.o: In function `sh_cmt_start':
clkdev.c:(.text+0x6f900): undefined reference to `clk_enable'
clkdev.c:(.text+0x6f93c): undefined reference to `clk_get_rate'
clkdev.c:(.text+0x6f95c): undefined reference to `clk_get_rate'
clkdev.c:(.text+0x6fa08): undefined reference to `clk_disable'
drivers/built-in.o: In function `sh_cmt_stop':
clkdev.c:(.text+0x6fc14): undefined reference to `clk_disable'
drivers/built-in.o: In function `__sh_tmu_disable':
clkdev.c:(.text+0x70590): undefined reference to `clk_disable'
drivers/built-in.o: In function `__sh_tmu_enable':
clkdev.c:(.text+0x70980): undefined reference to `clk_enable'
clkdev.c:(.text+0x709f0): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `em_sti_start':
clkdev.c:(.text+0x70f44): undefined reference to `clk_enable'
clkdev.c:(.text+0x70f68): undefined reference to `clk_get_rate'
drivers/built-in.o: In function `em_sti_stop':
clkdev.c:(.text+0x710d0): undefined reference to `clk_disable'
arch/arm/mach-shmobile/built-in.o: In function `shmobile_clk_init':
platsmp-apmu.c:(.init.text+0x7ac): undefined reference to
`recalculate_root_clocks'
platsmp-apmu.c:(.init.text+0x7b0): undefined reference to
`clk_enable_init_clocks'
arch/arm/mach-shmobile/built-in.o: In function `r8a7791_clock_init':
platsmp-apmu.c:(.init.text+0x8fc): undefined reference to `clk_register'
platsmp-apmu.c:(.init.text+0x920): undefined reference to `sh_clk_mstp_register'
arch/arm/mach-shmobile/built-in.o:(.data+0x16f0): undefined reference
to `followparent_recalc'

Both of my Koelsch legacy and reference configs have CONFIG_HAVE_CLK=y,
but only the reference once has CONFIG_COMMON_CLK=y.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
