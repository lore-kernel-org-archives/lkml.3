Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaHONbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:31:40 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:63734 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHONbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:31:39 -0400
MIME-Version: 1.0
In-Reply-To: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
References: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Fri, 15 Aug 2014 19:00:58 +0530
Message-ID: <CAGOxZ52uHbp-Ff6+ZK5v1-zcY3h9oSSsPvLh2ieCctYe0_irgA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: Add dependency on DMA
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Aug 14, 2014 at 10:15 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> The dw_mmc drivers rely on the DMA API, so update the Kconfig entry
> to depend on HAS_DMA.  Since the drivers should build on any platform
> with DMA, allow the driver to compile tested on non-ARC/ARM platforms.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

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



-- 
Regards,
Alim
