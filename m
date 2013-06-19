Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778Ab3FSPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:31:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:31:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 11/11] ARM: msm: Move MSM's DT based hardware to multi-platform support
Date: Wed, 19 Jun 2013 17:30:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org> <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191730.55203.arnd@arndb.de>
X-Provags-ID: V02:K0:QxjgI3njrd2E4qEIE0umDSGnc//hmmGk9jWXvXANps4
 lycGGKwLXaQ0etc11mNFXw9A7cooPDXTtsD3dvySGZBO/rJPBY
 Ty3hY2rTxauoCNA3nW017Vz5AwOVGEnyL8kVxKp/nHll9Qeofm
 KwMrV9Lp0YPIXHW+6L1CcqV4lHVMgVp7hZ9o+hDFnGZIk+8HnU
 tY7cIgVJ58CnPy0MFUF+z0UdcK5Lrg2zYQ5GatwfZD4mooHfX3
 48Hp8INsju68orqMVBiWfslT6ohNlQ/1+4lY8PqPFWf0cXFm/d
 KZ8ma7JjYN7Spr9xvGhrc4BduhKGWnUR8emyaCXoWXGd7Ch41o
 sdciGvhhNtxtwIMLSDX4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Stephen Boyd wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 430c922..22d4fff 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -618,8 +618,9 @@ config ARCH_PXA
>         help
>           Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
>  
> -config ARCH_MSM
> +config ARCH_MSM_NODT
>         bool "Qualcomm MSM"
> +       select ARCH_MSM
>         select ARCH_REQUIRE_GPIOLIB
>         select CLKDEV_LOOKUP
>         select CLKSRC_OF if OF


I think you have to adapt your defconfig after this change.

I'd suggest enabling all drivers for DT-based booting in
multi_v7_defconfig, and changing msm_defconfig to select
ARCH_MSM_NODT.

	Arnd
