Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHRLlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:41:09 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:60296 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHRLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
References: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
Date: Mon, 18 Aug 2014 13:41:05 +0200
Message-ID: <CAPDyKFoYkvoUTobZ4baA7g35is-YF7q5p8N4kFzwbj+ox992Kg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: Add dependency on DMA
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2014 18:45, Andrew Bresticker <abrestic@chromium.org> wrote:
> The dw_mmc drivers rely on the DMA API, so update the Kconfig entry
> to depend on HAS_DMA.  Since the drivers should build on any platform
> with DMA, allow the driver to compile tested on non-ARC/ARM platforms.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a565254..385674b 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -563,7 +563,8 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>
>  config MMC_DW
>         tristate "Synopsys DesignWare Memory Card Interface"
> -       depends on ARC || ARM
> +       depends on HAS_DMA
> +       depends on ARC || ARM || COMPILE_TEST
>         help
>           This selects support for the Synopsys DesignWare Mobile Storage IP
>           block, this provides host support for SD and MMC interfaces, in both
> --
> 2.1.0.rc2.206.gedb03e5
>
