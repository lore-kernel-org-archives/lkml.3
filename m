Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaLVJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:58:25 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50215 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaLVJ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <1418841126-13695-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1418841126-13695-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Mon, 22 Dec 2014 10:58:23 +0100
Message-ID: <CAPDyKFoxUbhXCHyDHaW5pcBt+aUgDB4SBLWBx7f7Nbcud==YhQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: stop trying to switch width when only one bit
 is supported
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2014 at 19:32, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> mmc_select_bus_width() will try to switch to MMC_BUS_WIDTH_4 even if
> MMC_CAP_4_BIT_DATA and MMC_CAP_8_BIT_DATA are not set in host->caps.
> Return as soon as possible when those flags are not set
>
> Fixes: 577fb13199b11d8cd75609183649be4b5561243f (mmc: rework
> selection of bus speed mode)
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: <stable@vger.kernel.org> # 3.17

Thanks! Applied for fixes.

Kind regards
Uffe

> ---
>  drivers/mmc/core/mmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 02ad79229f65..7466ce098e60 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -886,7 +886,7 @@ static int mmc_select_bus_width(struct mmc_card *card)
>         unsigned idx, bus_width = 0;
>         int err = 0;
>
> -       if (!mmc_can_ext_csd(card) &&
> +       if (!mmc_can_ext_csd(card) ||
>             !(host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA)))
>                 return 0;
>
> --
> 2.1.0
>
