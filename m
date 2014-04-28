Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaD1L1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:27:15 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:58700 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaD1L1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:27:13 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3SBQij1011639, This message is accepted by code: ctloc85258
Message-ID: <535E3BEC.9040100@realsil.com.cn>
Date: Mon, 28 Apr 2014 19:30:52 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v2 1/2] mmc: rtsx: add R1-no-CRC mmc command type handle
References: <cover.1395824147.git.micky_ching@realsil.com.cn> <afbc1328fb8a89fda3da23f1e9c755311450e1f6.1395824147.git.micky_ching@realsil.com.cn>
In-Reply-To: <afbc1328fb8a89fda3da23f1e9c755311450e1f6.1395824147.git.micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris and Ulf,

This patch should be applied to 3.15(rc), 3.14, 3.13.
without this patch the MMC card can not identified.

Best Regards.
micky.
On 03/27/2014 01:35 PM, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> commit a27fbf2f067b0cd6f172c8b696b9a44c58bfaa7a
> <mmc: add ignorance case for CMD13 CRC error>
> produced a cmd.flags unhandled in realtek pci host driver.
> This will make MMC card failed initialize, this patch is
> used to handle the new cmd.flags condition and MMC card can be used.
>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>   drivers/mmc/host/rtsx_pci_sdmmc.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 5fb994f..0d8904a 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -346,6 +346,9 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
>   	case MMC_RSP_R1:
>   		rsp_type = SD_RSP_TYPE_R1;
>   		break;
> +	case MMC_RSP_R1 & ~MMC_RSP_CRC:
> +		rsp_type = SD_RSP_TYPE_R1 | SD_NO_CHECK_CRC7;
> +		break;
>   	case MMC_RSP_R1B:
>   		rsp_type = SD_RSP_TYPE_R1b;
>   		break;

