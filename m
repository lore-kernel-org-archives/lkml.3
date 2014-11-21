Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaKULFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:05:16 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62486 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaKULFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:05:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        dinh.linux@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: socfpga: Set share override bit of the l2 cache controller
Date: Fri, 21 Nov 2014 12:04:43 +0100
Message-ID: <2156186.zs80uXCLAf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416546280-12068-2-git-send-email-dinguyen@opensource.altera.com>
References: <1416546280-12068-1-git-send-email-dinguyen@opensource.altera.com> <1416546280-12068-2-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XJLe8nFlnyHurWkAQeXsJfmiyu5UGTwRKfb3KgsimYD
 C8/W7kf0xHXCeeL3AGxLMBEgagWCisoWxgGOocPwPc+sBbTyLd
 q+1y3lucKmuGYBShfKffq/HqSfrpCRU0U0snlB1JMlHvtW4rbc
 SU3oqWnxnL1oln0IpuTJuOfLVm1huhz0SovpSIyx5hI9DXsYrq
 TyeH/x0rKg3mz+InGeLkZ8AS4BtxFBrYHSxT3R1APxNAjuzwqT
 CJKzOzxtDv5YB1TlfxLYVlyfw+UrGxhkYKAvRiXkqOaHPfFute
 MoIhYL7xgZXnv/870AmpJ02wMAkA3ce4Xwx6D6tafGGSfk5bQH
 7P1rBL+QDQHgwPY/N2V4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 23:04:40 dinguyen@opensource.altera.com wrote:
> 
> ---
>  arch/arm/mach-socfpga/socfpga.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
> index 13b1858..afc009f 100644
> --- a/arch/arm/mach-socfpga/socfpga.c
> +++ b/arch/arm/mach-socfpga/socfpga.c
> @@ -105,7 +105,8 @@ static const char *altera_dt_match[] = {
>  
>  DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
>         .l2c_aux_val    = L310_AUX_CTRL_DATA_PREFETCH |
> -                         L310_AUX_CTRL_INSTR_PREFETCH,
> +                         L310_AUX_CTRL_INSTR_PREFETCH |
> +                         L2C_AUX_CTRL_SHARED_OVERRIDE,
>         .l2c_aux_mask   = ~0,
>         .smp            = smp_ops(socfpga_smp_ops),
>         .map_io         = socfpga_map_io,

Hi Dinh,

Please do this by putting the appropriate proterties into the
l2x0 DT node instead.

	Arnd
