Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422662Ab3FTSzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:55:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030463Ab3FTSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:55:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v3 06/10] ARM:stixxxx: Add DEBUG_LL console support
Date: Thu, 20 Jun 2013 20:55:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737176-9473-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1371737176-9473-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306202055.43189.arnd@arndb.de>
X-Provags-ID: V02:K0:tQfjelmRw+4ZPRAIIdWQc7PzliUws+fI60Ja8hLZvhX
 aJMewmynhgjNbmWcKJ9fkjetBfnxrsv65DFNVsL0joghojm8Cm
 o8r89j6hIoQgyzDe4SYV0QtL9HUJpf2PFxYkH3KtwW9199asaL
 VrgwtFQBsoI5SE2FTJU+XJYUTWwLqm8YkUEQSDR5FsTZvNbFHS
 dLLKJCCn3Oi9zWhaN5FE0+8EXYKYSymXrZ7pB6TIKzZ3CDBi1J
 QVCzlUVqyrA7tE0+YXV4kVfnHYQuAMB1AsntiJf51pgE0sRuaj
 hnYl9Qqj/I8FAKAKcSr5acpshfJGGbzxGTgxrAUZnzMhnJra3a
 7psjceKLVDCm60UwvTT0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
> --- a/arch/arm/mach-stixxxx/board-dt.c
> +++ b/arch/arm/mach-stixxxx/board-dt.c
> @@ -11,6 +11,7 @@
>  #include <linux/clocksource.h>
>  #include <linux/irq.h>
>  #include <asm/hardware/cache-l2x0.h>
> +#include <asm/mach/map.h>
>  #include <asm/mach/arch.h>
>  
>  #include "smp.h"
> @@ -42,6 +43,7 @@ static const char *stih41x_dt_match[] __initdata = {
>  };
>  
>  DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
> +       .map_io         = debug_ll_io_init,
>         .init_time      = stih41x_timer_init,
>         .smp            = smp_ops(stixxxx_smp_ops),
>         .dt_compat      = stih41x_dt_match,

This part of the patch is no longer needed, we do the same when .map_io
is not set.

	Arnd
