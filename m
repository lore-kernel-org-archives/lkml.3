Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbaGOKdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:33:16 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:49653 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaGOKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 15 Jul 2014 16:03:04 +0530
Message-ID: <CAMf-jSnLDhJKhRbohM17kadTtbKQBqSNZ1Jj8yvPYV_hL+fRNg@mail.gmail.com>
Subject: Re: [RFC/PATCH 00/12] Krait clocks + Krait CPUfreq
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jun 25, 2014 at 5:36 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

>
> Stephen Boyd (12):
>   ARM: Add Krait L2 register accessor functions
>   clk: Add safe switch hook
>   clk: qcom: Add support for muxes, dividers, and mux dividers
>   clk: qcom: Add support for High-Frequency PLLs (HFPLLs)
>   clk: qcom: Add HFPLL driver
>   clk: qcom: Add MSM8960's HFPLLs
>   clk: qcom: Add support for Krait clocks
>   clk: qcom: Add KPSS ACC/GCC driver
>   clk: qcom: Add Krait clock controller driver
>   cpufreq: Add a cpufreq-krait based on cpufreq-cpu0
>   cpufreq: Add module to register cpufreq-krait device
>   ARM: dts: qcom: Add necessary DT data for Krait cpufreq
>

I have applied all these patches on 3.16-rc3. Compiled with below
minor change in drivers/cpufreq/Makefile to get cpufreq-krait.c
compiled:

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 6b8917b..8afbea4 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)       +=
cpufreq_conservative.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)              += cpufreq_governor.o

 obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)     += cpufreq-cpu0.o
-obj-$(CONFIG_CPUFREQ_KRAIT)            += cpufreq-krait.o
+obj-$(CONFIG_GENERIC_CPUFREQ_KRAIT)    += cpufreq-krait.o

 ##################################################################################
 # x86 drivers.

Tested cpufreq by enabling all governors in kernel. Tests done on
DB8074 board and Seen the frequency scaling as expected.

>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
