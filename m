Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3EIT3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:29:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39827 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752237Ab3EIT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:29:14 -0400
Date: Thu, 9 May 2013 15:29:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Libo Chen <libo.chen@huawei.com>
cc: grant.likely@linaro.org, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 1/4] usb: ehci-s5p: fix memleak when devm_usb_get_phy
 fail
In-Reply-To: <1368079537-15328-2-git-send-email-libo.chen@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1305091529000.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Libo Chen wrote:

> When devm_usb_get_phy fail, we should free hcd
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ehci-s5p.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 6357752..3fbab58 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -107,6 +107,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  	if (IS_ERR(phy)) {
>  		/* Fallback to pdata */
>  		if (!pdata) {
> +			usb_put_hcd(hcd);
>  			dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
>  			return -EPROBE_DEFER;
>  		} else {

Acked-by: Alan Stern <stern@rowland.harvard.edu>

