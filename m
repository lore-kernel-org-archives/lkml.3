Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3LDCCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:02:30 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:52865 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3LDCC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:02:26 -0500
Message-ID: <529E8D2F.3070706@gtsys.com.hk>
Date: Wed, 04 Dec 2013 10:02:23 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: balbi@ti.com, gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] usb: phy-tegra-usb.c: wrong pointer check for remap
 UTMI
References: <1386122435-4205-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1386122435-4205-1-git-send-email-chris.ruehl@gtsys.com.hk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, it should be [PATCH] only .. I will resend it.


On Wednesday, December 04, 2013 10:00 AM, Chris Ruehl wrote:
> usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
>
> A wrong pointer was used to test the result of devm_ioremap()
>
> Signed-off-by: Chris Ruehl<chris.ruehl@gtsys.com.hk>
> Acked-by: Venu Byravarasu<vbyravarasu@nvidia.com>
> ---
>   drivers/usb/phy/phy-tegra-usb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
> index 82232ac..bbe4f8e 100644
> --- a/drivers/usb/phy/phy-tegra-usb.c
> +++ b/drivers/usb/phy/phy-tegra-usb.c
> @@ -876,7 +876,7 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
>
>   	tegra_phy->pad_regs = devm_ioremap(&pdev->dev, res->start,
>   		resource_size(res));
> -	if (!tegra_phy->regs) {
> +	if (!tegra_phy->pad_regs) {
>   		dev_err(&pdev->dev, "Failed to remap UTMI Pad regs\n");
>   		return -ENOMEM;
>   	}

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
