Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3DXDNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:13:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50183 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab3DXDNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:13:11 -0400
Message-ID: <51774DC6.806@windriver.com>
Date: Wed, 24 Apr 2013 11:13:10 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: ehci-fsl: set INCR8 mode only on MPC512x
References: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore this temporarily since looks this is already covered in tree.

I will look further into this to send another version.

Tiejun

On 04/24/2013 10:55 AM, Tiejun Chen wrote:
> commit 761bbcb7, "usb: ehci-fsl: set INCR8 mode for system bus interface
> on MPC512x", introduced to fix one MPC5121e (M36P) Errata by setting
> INCR8 mode for system bus interface on MPC512x, but we should make sure
> this is only valid for MPC512x like other parts of this commit. Otherwise
> this would issue other platforms as abnormal without this similar Errata.
>
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>   drivers/usb/host/ehci-fsl.c |   10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
> index d81d2fc..f4f2a7b 100644
> --- a/drivers/usb/host/ehci-fsl.c
> +++ b/drivers/usb/host/ehci-fsl.c
> @@ -509,7 +509,15 @@ static int ehci_fsl_mpc512x_drv_resume(struct device *dev)
>   	ehci_writel(ehci, ISIPHYCTRL_PXE | ISIPHYCTRL_PHYE,
>   		    hcd->regs + FSL_SOC_USB_ISIPHYCTRL);
>
> -	ehci_writel(ehci, SBUSCFG_INCR8, hcd->regs + FSL_SOC_USB_SBUSCFG);
> +	if (of_device_is_compatible(dev->parent->of_node,
> +				    "fsl,mpc5121-usb2-dr")) {
> +		/*
> +		 * set SBUSCFG:AHBBRST so that control msgs don't
> +		 * fail when doing heavy PATA writes.
> +		 */
> +		ehci_writel(ehci, SBUSCFG_INCR8,
> +			    hcd->regs + FSL_SOC_USB_SBUSCFG);
> +	}
>
>   	/* restore EHCI registers */
>   	ehci_writel(ehci, pdata->pm_command, &ehci->regs->command);
>

