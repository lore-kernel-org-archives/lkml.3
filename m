Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3BKRx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:53:27 -0500
Received: from void.printf.net ([89.145.121.20]:37661 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520Ab3BKRxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:53:25 -0500
From: Chris Ball <cjb@laptop.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 1/3] MMC: rtsx: remove driving adjustment
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
	<1359963959-2305-2-git-send-email-rogerable@realtek.com>
Date: Mon, 11 Feb 2013 12:53:13 -0500
In-Reply-To: <1359963959-2305-2-git-send-email-rogerable@realtek.com> (Roger
	Tseng's message of "Mon, 4 Feb 2013 15:45:57 +0800")
Message-ID: <87txpipwja.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 04 2013, Roger Tseng wrote:
> Several new models of readers use different way to select driving
> capability(a necessary adjustment along with voltage change). Removing this
> from device-independent rtsx_pci_sdmmc module. It will be implemented in
> device-depend calls encapsulated by rtsx_pci_switch_output_voltage().
>
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Reviewed-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index f74b5ad..f93f100 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -1083,11 +1083,6 @@ static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>  		voltage = OUTPUT_1V8;
>  
>  	if (voltage == OUTPUT_1V8) {
> -		err = rtsx_pci_write_register(pcr,
> -				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
> -		if (err < 0)
> -			goto out;
> -
>  		err = sd_wait_voltage_stable_1(host);
>  		if (err < 0)
>  			goto out;

Thanks, I've pushed 1/3 to mmc-next for 3.9 now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
