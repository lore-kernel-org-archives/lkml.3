Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3DVO27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:28:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15372 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3DVO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:28:58 -0400
X-AuditID: cbfec7f4-b7fb86d000007679-e6-517549271850
Message-id: <51754923.8020609@samsung.com>
Date: Mon, 22 Apr 2013 16:28:51 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328
 Thunderbird/17.0.5
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: lp3971: Convert to use
 regulator_map_voltage_ascend
References: <1366475731.7038.1.camel@phoenix>
In-reply-to: <1366475731.7038.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xa7rqnqWBBus/m1kcmfOV2eLf7FNs
	Ft+udDBZXN41h82BxWPnrLvsHm0/yzxeTvzN5vF5k1wASxSXTUpqTmZZapG+XQJXxt0tU5kK
	vnFV9P3vZGlgbOTsYuTkkBAwkeh4dIMVwhaTuHBvPVsXIxeHkMBSRokPj7ewQzjNTBLHbj9j
	A6niFdCS+PR3BzOIzSKgKtH/8iOYzSZgKNH1tgusRlQgVOLzgzaoekGJH5PvsYDYIgJKEqvu
	XwazmQUqJbob/4PVCAtESnQufgdmCwnoSqy/cgpsJqeAnsSZ7/uYIOrNJB61rGOGsOUlNq95
	yzyBUWAWkhWzkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI8H7Zwbj4mNUh
	RgEORiUeXkH30kAh1sSy4srcQ4wSHMxKIrx3X5cECvGmJFZWpRblxxeV5qQWH2Jk4uCUamAU
	dTcWu7vz64ewDwsO+2z5e9T4Ntuen6eWCutFnmjs/Xg4webeHxvGNwqci2OzHsX5F3y6uIWx
	MkrVuFb3XevvJC8ppdtrXn6atGxd882P5R/qHXw7OUNW23P/k9x565LILL8I22Jz5qCKa9NW
	vJ99K0cw/6xxlo9grEFY63TRuDwl4YwA1ndKLMUZiYZazEXFiQBhfYa9PAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-04-20 18:35, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Thus use regulator_map_voltage_ascend is more efficient than the default
> regulator_map_voltage_iterate.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/regulator/lp3971.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
> index 9cb2c0f..d8af9e7 100644
> --- a/drivers/regulator/lp3971.c
> +++ b/drivers/regulator/lp3971.c
> @@ -163,6 +163,7 @@ static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
>   
>   static struct regulator_ops lp3971_ldo_ops = {
>   	.list_voltage = regulator_list_voltage_table,
> +	.map_voltage = regulator_map_voltage_ascend,
>   	.is_enabled = lp3971_ldo_is_enabled,
>   	.enable = lp3971_ldo_enable,
>   	.disable = lp3971_ldo_disable,
> @@ -236,6 +237,7 @@ static int lp3971_dcdc_set_voltage_sel(struct regulator_dev *dev,
>   
>   static struct regulator_ops lp3971_dcdc_ops = {
>   	.list_voltage = regulator_list_voltage_table,
> +	.map_voltage = regulator_map_voltage_ascend,
>   	.is_enabled = lp3971_dcdc_is_enabled,
>   	.enable = lp3971_dcdc_enable,
>   	.disable = lp3971_dcdc_disable,

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


