Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaJ0NjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:39:12 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57306 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaJ0NjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-4-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 27 Oct 2014 14:39:04 +0100
Message-ID: <CAPDyKFo+sSgc+J5uiNyhzwF69ncLmo7aoVgUB5O1JA4MrhhPbA@mail.gmail.com>
Subject: Re: [PATCH RESEND 03/12] mmc: sdhci-pxav3: Move private driver data
 to driver source
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 11:22, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> struct sdhci_pxa is only used in sdhci_pxa driver itself, so move it
> there.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-pxav3.c          | 5 +++++
>  include/linux/platform_data/pxa_sdhci.h | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index b55c807982fe..48bc8179c8fc 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -58,6 +58,11 @@
>  #define SDCE_MISC_INT          (1<<2)
>  #define SDCE_MISC_INT_EN       (1<<1)
>
> +struct sdhci_pxa {
> +       u8      clk_enable;
> +       u8      power_mode;
> +};
> +
>  /*
>   * These registers are relative to the second register region, for the
>   * MBus bridge.
> diff --git a/include/linux/platform_data/pxa_sdhci.h b/include/linux/platform_data/pxa_sdhci.h
> index 27d3156d093a..9e20c2fb4ffd 100644
> --- a/include/linux/platform_data/pxa_sdhci.h
> +++ b/include/linux/platform_data/pxa_sdhci.h
> @@ -55,9 +55,4 @@ struct sdhci_pxa_platdata {
>         unsigned int    quirks2;
>         unsigned int    pm_caps;
>  };
> -
> -struct sdhci_pxa {
> -       u8      clk_enable;
> -       u8      power_mode;
> -};
>  #endif /* _PXA_SDHCI_H_ */
> --
> 2.1.1
>
