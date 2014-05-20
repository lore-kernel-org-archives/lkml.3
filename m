Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaETJSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:18:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38923 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaETJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:18:17 -0400
Message-ID: <537B1DD3.2040104@gmail.com>
Date: Tue, 20 May 2014 11:18:11 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/7] ata: ahci_platform: add the Marvell Berlin AHCI
 compatible
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com> <1400576675-25265-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1400576675-25265-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 11:04 AM, Antoine Ténart wrote:
> The Marvell Berlin AHCI has all his specific in the PHY driver. It then
> only need to use the libahci functions to work properly.

If it is that generic, ..

> Add its compatible into the libahci_platform driver.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   drivers/ata/ahci_platform.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index ef67e79944f9..bc050aabf206 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -76,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
>   	{ .compatible = "snps,exynos5440-ahci", },
>   	{ .compatible = "ibm,476gtr-ahci", },
>   	{ .compatible = "snps,dwc-ahci", },
> +	{ .compatible = "marvell,berlin-ahci", },

.. why have a Marvell-specific compatible?

How about "generic-ahci" instead, like we have for other fooHCIs
already?

Sebastian

>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, ahci_of_match);
>

