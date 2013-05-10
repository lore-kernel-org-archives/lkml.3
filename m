Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3EJSGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:06:44 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53257 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3EJSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:06:43 -0400
Message-ID: <518D3738.6040402@cogentembedded.com>
Date: Fri, 10 May 2013 22:06:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, swarren@wwwdotorg.org, balbi@ti.com,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 08/10] usb: phy: tegra: Add error handling & clean
 up.
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com> <1368194051-4925-9-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1368194051-4925-9-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/10/2013 05:54 PM, Venu Byravarasu wrote:

> Check return values from all GPIO APIs and handle errors accordingly.
>
> Remove the call to clk_disable_unprepare(); this function does not
> prepare or enable the clock, so the error path should not disable or
> unprepare it.
>
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
[...]
> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
> index a2a89a9..dce692a 100644
> --- a/drivers/usb/phy/phy-tegra-usb.c
> +++ b/drivers/usb/phy/phy-tegra-usb.c
[...]
> @@ -624,24 +632,44 @@ static int	tegra_phy_init(struct usb_phy *x)
[...]
>   		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
> +		if (!phy->ulpi) {
> +			dev_err(phy->dev, "otg_ulpi_create returned err\n");

    Rather "returned NULL".

WBR, Sergei

