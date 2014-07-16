Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaGPJeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:34:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33198 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaGPJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:34:32 -0400
Message-ID: <53C646DA.3020002@gmail.com>
Date: Wed, 16 Jul 2014 15:03:14 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/12] phy: add the Berlin USB PHY driver
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <1405499166-6726-6-git-send-email-antoine.tenart@free-electrons.com> <53C64389.3050705@gmail.com> <20140716092541.GC28151@kwain>
In-Reply-To: <20140716092541.GC28151@kwain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:55 PM, Antoine Ténart wrote:
> Hi Varka,
>
> On Wed, Jul 16, 2014 at 02:49:05PM +0530, Varka Bhadram wrote:
>> On 07/16/2014 01:55 PM, Antoine Ténart wrote:
>>> +static const struct of_device_id phy_berlin_sata_of_match[] = {
>>> +	{
>>> +		.compatible = "marvell,berlin2-usb-phy",
>>> +		.data = &phy_berlin_pll_dividers[0],
>>> +	},
>>> +	{
>>> +		.compatible = "marvell,berlin2cd-usb-phy",
>>> +		.data = &phy_berlin_pll_dividers[1],
>>> +	},
>>> +	{ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, phy_berlin_sata_of_match);
>>> +
>> It looks good if we move this after probe().. So that we can see of_match_table directly...
> We use the of match table in the probe, when calling of_match_device().
>
>>> +static int phy_berlin_usb_probe(struct platform_device *pdev)
>>> +{
>>> +	const struct of_device_id *match =
>>> +		of_match_device(phy_berlin_sata_of_match, &pdev->dev);

We are updating of_match_table in platform_driver struct.

Every driver follows the concept of giving the of_device_ids
above the platform_driver declaration...

> Here.
>
> Antoine
>
