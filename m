Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaLDI5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:57:46 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:39430 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125AbaLDI5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:57:45 -0500
Message-ID: <548021E2.2080506@arm.com>
Date: Thu, 04 Dec 2014 08:57:06 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: dwc: Allocate resources with devm_ioremap_resource
References: <547F3C96.9070509@arm.com> <547F3DD0.10405@metafoo.de>
In-Reply-To: <547F3DD0.10405@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 16:44, Lars-Peter Clausen wrote:
> On 12/03/2014 05:38 PM, Andrew Jackson wrote:
> [,,,[
>> +	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
>> +	if (!dw_i2s_dai) {
>> +		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
> 
> All the memory alloc functions already print a error message.

I will remove the error message(s).

>>   		return -ENOMEM;
>>   	}
>>
>> +	dw_i2s_dai->ops = &dw_i2s_dai_ops;
>> +	dw_i2s_dai->suspend = dw_i2s_suspend;
>> +	dw_i2s_dai->resume = dw_i2s_resume;
> 
> This seems to be separate from the devm_ioremap_resource() change.

It seemed reasonable to assign these known values to the dw_i2s_dai as soon as it had been allocated. Would you prefer this in a separate patch?

>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
> 
> You don't actually have to check it devm_ioremap_resource does this for you.

Oh, thanks, paranoia was taking over.

>> +		dev_err(&pdev->dev, "no i2s resource defined\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(dev->i2s_base)) {
>> +		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
> 
> Same here devm_ioremap_resource() will already print a appropriate error 
> message.
> 
>> +		return PTR_ERR(dev->i2s_base);
>> +	}
> 
> 

