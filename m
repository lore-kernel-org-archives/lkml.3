Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaJ0MBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:01:15 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:54605 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaJ0MBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <1411525744-4215-1-git-send-email-peter.guo@bayhubtech.com>
References: <1411525744-4215-1-git-send-email-peter.guo@bayhubtech.com>
Date: Mon, 27 Oct 2014 13:01:13 +0100
Message-ID: <CAPDyKFp1JZMxKkjjdwv-tfcouHKKn_Hkw3VrPhoQ=5yty2JU9g@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci-o2micro: Fix Dell E5440 issue
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "peter.guo" <peter.guo@bayhubtech.com>
Cc: Chris Ball <chris@printf.net>,
        "adam.lee@canonical.com" <adam.lee@canonical.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Guan <samuel.guan@bayhubtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 04:29, peter.guo <peter.guo@bayhubtech.com> wrote:
> From: "peter guo" <peter.guo@bayhubtech.com>
>
> Fix Dell E5440 when reboot Linux, can't find o2micro sd host chip issue.
>
> Signed-off-by: peter guo <peter.guo@bayhubtech.com>

Thanks! Applied for next!

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-pci-o2micro.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
> index 5670e38..e2ec108d 100644
> --- a/drivers/mmc/host/sdhci-pci-o2micro.c
> +++ b/drivers/mmc/host/sdhci-pci-o2micro.c
> @@ -127,8 +127,6 @@ void sdhci_pci_o2_fujin2_pci_init(struct sdhci_pci_chip *chip)
>                 return;
>         scratch_32 &= ~((1 << 21) | (1 << 30));
>
> -       /* Set RTD3 function disabled */
> -       scratch_32 |= ((1 << 29) | (1 << 28));
>         pci_write_config_dword(chip->pdev, O2_SD_FUNC_REG3, scratch_32);
>
>         /* Set L1 Entrance Timer */
> --
> 1.9.1
>
