Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaBEApM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:45:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40411 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaBEApK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:45:10 -0500
Date: Tue, 4 Feb 2014 16:45:09 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] arm: qcom: Split Qualcomm support into legacy
 and multiplatform
Message-ID: <20140205004509.GA12815@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org>
 <1391553532-27001-4-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391553532-27001-4-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Kumar Gala wrote:
> Introduce a new mach-qcom that will support SoCs that intend to be
> multiplatform compatiable while keeping mach-msm to legacy SoC/board

s/compatiable/compatible/

> support that will not transition over to multiplatform.
> 
> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
> to mach-qcom.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

> diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
> new file mode 100644
> index 0000000..755b0db
> --- /dev/null
> +++ b/arch/arm/mach-qcom/Kconfig
> @@ -0,0 +1,33 @@
> +config ARCH_QCOM
> +	bool "Qualcomm Support" if ARCH_MULTI_V7
> +	select ARCH_REQUIRE_GPIOLIB
> +	select CLKSRC_OF
> +	select GENERIC_CLOCKEVENTS

I wonder why this isn't part of CONFIG_ARCH_MULTIPLATFORM.

> +	select ARM_GIC
> +	select HAVE_SMP
> +	select QCOM_SCM if SMP

Please sort this alphabetically.

> +	help
> +	  Support for Qualcomm's devicetree based systems.
> +
> +if ARCH_QCOM
> +
> diff --git a/arch/arm/mach-qcom/Makefile b/arch/arm/mach-qcom/Makefile
> new file mode 100644
> index 0000000..c0ba0ef
> --- /dev/null
> +++ b/arch/arm/mach-qcom/Makefile
> @@ -0,0 +1,5 @@
> +obj-y			:= board.o
> +obj-$(CONFIG_SMP)	+= smp.o

Everyone else on ARM calls it platsmp.c. Why differ?

> +obj-$(CONFIG_QCOM_SCM)	+= scm.o scm-boot.o
> +
> +CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
