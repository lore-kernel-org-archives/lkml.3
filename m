Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3DAIcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:32:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52989 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab3DAIcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:32:13 -0400
Message-ID: <51594665.1090903@ti.com>
Date: Mon, 1 Apr 2013 14:03:41 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] RX-51: ARM errata 430973 workaround
References: <20130328155803.GT10155@atomide.com> <1364738063-23868-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1364738063-23868-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 March 2013 07:24 PM, Pali Rohár wrote:
> Closed and signed Nokia X-Loader bootloader stored in RX-51 nand does not set
> IBE bit in ACTLR and starting kernel in non-secure mode. So direct write to
> ACTLR by our kernel does not working and the code for ARM errata 430973 in
> commit 7ce236fcd6fd45b0441a2d49acb2ceb2de2e8a47 that sets IBE bit is a noop.
> 
> In order to have workaround for ARM errata 430973 from non-secure world on
> RX-51 we needs Secure Monitor Call to set IBE BIT in ACTLR.
> 
> This patch adds RX-51 specific SMC support and sets IBE bit in ACTLR during
> board init code for ARM errata 430973 workaround.
> 
> Because all the setup and what arguments are required for SMC are completely
> different from SoC to SoC it is not possible to create generic SMC handling.
> Code in omap-smc.S looks identical but it is not. So RX-51 needs another code.
> 
> ARM errata 430973 workaround is needed for thumb-2 ISA compiled userspace
> binaries. Without this workaround thumb-2 binaries crashing. So with this
> patch it is possible to recompile and run applications/binaries with thumb-2
> ISA on RX-51.
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/Makefile            |    1 +
>  arch/arm/mach-omap2/board-rx51-secure.c |   66 +++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-rx51-secure.h |   36 +++++++++++++++++
>  arch/arm/mach-omap2/board-rx51-smc.S    |   34 ++++++++++++++++
>  arch/arm/mach-omap2/board-rx51.c        |    7 ++++
>  5 files changed, 144 insertions(+)
>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.c
>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.h
>  create mode 100644 arch/arm/mach-omap2/board-rx51-smc.S
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-smc.S b/arch/arm/mach-omap2/board-rx51-smc.S
> new file mode 100644
> index 0000000..70e2eb7
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-rx51-smc.S
> @@ -0,0 +1,34 @@
You can avoid creating board-rx51-smc.S by having rx51_ppa_smc()
part of board-rx51-secure.c using inline asm. You can avoid the
board-rx51-secure.h as well considering the usage is limited to
the rx51 board.

Regards,
Santosh
