Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481AbaGRObu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:31:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934407AbaGRObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:31:48 -0400
Message-ID: <53C92F8E.5000906@redhat.com>
Date: Fri, 18 Jul 2014 16:30:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 5/8] ata: ahci_platform: add a generic AHCI compatible
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com> <1405686607-8126-6-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1405686607-8126-6-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/18/2014 02:30 PM, Antoine Ténart wrote:
> The ahci_platform driver is a generic driver using the libahci_platform
> functions. Add a generic compatible to avoid having an endless list of
> compatibles with no differences for the same driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/ata/ahci_platform.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 95f9ca82082a..61b15e784020 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -77,6 +77,8 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_platform_suspend,
>  			 ahci_platform_resume);
>  
>  static const struct of_device_id ahci_of_match[] = {
> +	{ .compatible = "generic-ahci", },
> +	/* Keep the following compatibles for device tree compatibility */
>  	{ .compatible = "snps,spear-ahci", },
>  	{ .compatible = "snps,exynos5440-ahci", },
>  	{ .compatible = "ibm,476gtr-ahci", },
> 

I'm not against this, I've introduced the same for the ehci / uhci platform
driver after all, but this should be documented in Documentation/devicetree,
and please make sure to mention in the docs that the correct way to use this
inside a dts file is:

	compatible = "manufacturer,soc-model-ahci", "generic-ahci";

So that we can later add quirks for the specific soc if necessary without
needing to change the dts.

Regards,

Hans
