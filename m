Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab3B0O3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:29:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4169 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975Ab3B0O3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:29:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Feb 2013 06:24:21 -0800
Message-ID: <512E1813.7040105@nvidia.com>
Date: Wed, 27 Feb 2013 19:58:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>, "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: use correct device node for DT parsing
References: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com> <512E16EE.2050201@slimlogic.co.uk>
In-Reply-To: <512E16EE.2050201@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013 07:53 PM, Graeme Gregory wrote:
> On 27/02/13 14:10, Laxman Dewangan wrote:
>> When device is registered through the DT then regulators node
>> exist in the parent device node of regulator driver. Hence passing
>> parent device node for parsing DT in place of self-device node
>> which is typically NULL.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>>   drivers/regulator/palmas-regulator.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
>> index e915629..f07501d 100644
>> --- a/drivers/regulator/palmas-regulator.c
>> +++ b/drivers/regulator/palmas-regulator.c
>> @@ -591,7 +591,7 @@ static int palmas_probe(struct platform_device *pdev)
>>   {
>>   	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
>>   	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
>> -	struct device_node *node = pdev->dev.of_node;
>> +	struct device_node *node = pdev->dev.parent->of_node;
>>   	struct regulator_dev *rdev;
>>   	struct regulator_config config = { };
>>   	struct palmas_pmic *pmic;
> This is not correct, nor is the reasoning.
>
> I suspect your previous patch broke DT probing so your not getting nodes
> filled in.
>

I pasted my DT files in other patch for discussion. This is the way we 
are following for other device and DT file population.
Probably, I need to see your test DT file for more discussion.
