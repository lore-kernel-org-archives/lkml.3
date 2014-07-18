Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbaGRMzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:55:54 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64211 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaGRMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:55:52 -0400
Message-ID: <53C918FE.8040303@gmail.com>
Date: Fri, 18 Jul 2014 18:24:22 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/8] phy: add a driver for the Berlin SATA PHY
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com> <1405686607-8126-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1405686607-8126-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 06:00 PM, Antoine Ténart wrote:
> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>
> The mode selection can let us think this PHY can be configured to fit
> other purposes. But there are reasons to think the SATA mode will be
> the only one usable: the PHY registers are only accessible indirectly
> through two registers in the SATA range, the PHY seems to be integrated
> and no information tells us the contrary. For these reasons, make the
> driver a SATA PHY driver.
>
(...)

> +
> +static const struct of_device_id phy_berlin_sata_of_match[] = {
> +	{ .compatible = "marvell,berlin2q-sata-phy" },
> +	{ },
> +};
> +
> +static struct platform_driver phy_berlin_sata_driver = {
> +	.probe	= phy_berlin_sata_probe,
> +	.driver	= {
> +		.name		= "phy-berlin-sata",
> +		.owner		= THIS_MODULE,

owner filed automatically update with module_platform_driver().

see:http://lxr.free-electrons.com/source/include/linux/platform_device.h#L190
  

-- 
Regards,
Varka Bhadram.

