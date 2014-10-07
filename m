Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaJGJNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:13:08 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:64700 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJGJNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:13:05 -0400
Date: Tue, 7 Oct 2014 10:12:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: rtsx: Fix build warnings for !PM
Message-ID: <20141007091259.GL25331@lee--X1>
References: <1412234717-4699-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412234717-4699-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Oct 2014, Thierry Reding wrote:

> From: Thierry Reding <treding@nvidia.com>
> 
> rtsx_pci_power_off() is called only from rtsx_pci_suspend(), which isn't
> built when PM is disabled.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/mfd/rtsx_pcr.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to fixes.

> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index f2643c221d34..30f7ca89a0e6 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -947,6 +947,7 @@ static void rtsx_pci_idle_work(struct work_struct *work)
>  	mutex_unlock(&pcr->pcr_mutex);
>  }
>  
> +#ifdef CONFIG_PM
>  static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
>  {
>  	if (pcr->ops->turn_off_led)
> @@ -961,6 +962,7 @@ static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
>  	if (pcr->ops->force_power_down)
>  		pcr->ops->force_power_down(pcr, pm_state);
>  }
> +#endif
>  
>  static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
>  {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
