Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaKMLrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:47:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39161 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932552AbaKMLrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:47:03 -0500
Message-ID: <54649A25.6050304@free-electrons.com>
Date: Thu, 13 Nov 2014 12:46:45 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] phy: add support for USB cluster on the Armada
 375 SoC
References: <1415786237-21985-1-git-send-email-gregory.clement@free-electrons.com> <1415786237-21985-5-git-send-email-gregory.clement@free-electrons.com> <54644C92.8000900@ti.com>
In-Reply-To: <54644C92.8000900@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
>> +
>> +static struct armada375_cluster_phy usb_cluster_phy;
> 
> don't use global variables.
>> +
>> +static int armada375_usb_phy_init(struct phy *phy)
>> +{
>> +	struct armada375_cluster_phy *cluster_phy = phy_get_drvdata(phy);
>> +	u32 reg;
>> +
>> +	reg = readl(cluster_phy->reg);
>> +	if (cluster_phy->use_usb3)
>> +		reg |= USB2_PHY_CONFIG_DISABLE;
>> +	else
>> +		reg &= ~USB2_PHY_CONFIG_DISABLE;
>> +	writel(reg, cluster_phy->reg);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct phy_ops armada375_usb_phy_ops = {
>> +	.init = armada375_usb_phy_init,
>> +	.owner = THIS_MODULE,
>> +};
>> +
>> +/*
>> + * Only one controller can use this PHY. We shouldn't have the case
>> + * when two controllers want to use this PHY. But if this case occurs
>> + * then we provide a phy to the first one and return an error for the
>> + * next one. This error has also to be an error returned by
>> + * devm_phy_optional_get() so different from ENODEV for USB2. In the
>> + * USB3 case it still optional and we use ENODEV.
>> + */
>> +static struct phy *armada375_usb_phy_xlate(struct device *dev,
>> +					struct of_phandle_args *args)
>> +{
>> +
>> +    /*
>> +     * Either the phy had never been requested and then the first usb
>> +     * claiming it can get it, or it had already been requested in
>> +     * this case, we only allow to use it with the same configuration.
>> +     */
> 
> You can dynamically create usb_cluster_phy in probe and then invoke
> platform_set_drvdata by passing *usb_cluster_phy. Then you can invoke
> platform_get_drvdata here to get *usb_cluster_phy.
> 
> While fixing this also add yourself as Maintainer of this file.

I am taking into account your comment and I am going to send a new version soon.

Thanks,

Gregory


> 
> Thanks
> Kishon
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
