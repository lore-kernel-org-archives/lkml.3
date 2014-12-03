Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaLCQn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:43:56 -0500
Received: from smtp-out-200.synserver.de ([212.40.185.200]:1093 "EHLO
	smtp-out-200.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:43:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31494
Message-ID: <547F3DD0.10405@metafoo.de>
Date: Wed, 03 Dec 2014 17:44:00 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Andrew Jackson <Andrew.Jackson@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: dwc: Allocate resources with devm_ioremap_resource
References: <547F3C96.9070509@arm.com>
In-Reply-To: <547F3C96.9070509@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 05:38 PM, Andrew Jackson wrote:
[,,,[
> +	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
> +	if (!dw_i2s_dai) {
> +		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");

All the memory alloc functions already print a error message.

>   		return -ENOMEM;
>   	}
>
> +	dw_i2s_dai->ops = &dw_i2s_dai_ops;
> +	dw_i2s_dai->suspend = dw_i2s_suspend;
> +	dw_i2s_dai->resume = dw_i2s_resume;

This seems to be separate from the devm_ioremap_resource() change.

> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {

You don't actually have to check it devm_ioremap_resource does this for you.

> +		dev_err(&pdev->dev, "no i2s resource defined\n");
> +		return -ENODEV;
> +	}
> +
> +	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(dev->i2s_base)) {
> +		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");

Same here devm_ioremap_resource() will already print a appropriate error 
message.

> +		return PTR_ERR(dev->i2s_base);
> +	}

