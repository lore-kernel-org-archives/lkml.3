Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbaGYGTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:19:10 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63429 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGYGTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:19:08 -0400
Message-ID: <53D1F686.30600@gmail.com>
Date: Fri, 25 Jul 2014 11:47:42 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, broonie@kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, timur@tabi.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        shawn.guo@linaro.org, b02247@freescale.com, b42378@freescale.com,
        tklauser@distanz.ch
Subject: Re: [PATCH v3 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform
 drivers
References: <cover.1406259578.git.nicoleotsuka@gmail.com> <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com> <53D1DC0B.1000905@gmail.com> <20140725055447.GC29136@MrMyself>
In-Reply-To: <20140725055447.GC29136@MrMyself>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolin,

On 07/25/2014 11:24 AM, Nicolin Chen wrote:
> Hi Varka,
>
>     Regarding a point you suggested.
>
> On Fri, Jul 25, 2014 at 09:54:43AM +0530, Varka Bhadram wrote:
>> On 07/25/2014 09:33 AM, Nicolin Chen wrote:
>> (...)
>>
>>> +
>>> +static const struct platform_device_id fsl_asrc_devtype[] = {
>>> +	{
>>> +		.name = "imx35-asrc",
>>> +		.driver_data = IMX35_ASRC,
>>> +	}, {
>>> +		.name = "imx53-asrc",
>>> +		.driver_data = IMX53_ASRC,
>>> +	}, {
>>> +		/* sentinel */
>>> +	}
>>> +};
>>> +MODULE_DEVICE_TABLE(platform, fsl_asrc_devtype);
>>> +
>>> +static const struct of_device_id fsl_asrc_ids[] = {
>>> +	{
>>> +		.compatible = "fsl,imx35-asrc",
>>> +		.data = &fsl_asrc_devtype[IMX35_ASRC],
>>> +	}, {
>>> +		.compatible = "fsl,imx53-asrc",
>>> +		.data = &fsl_asrc_devtype[IMX53_ASRC],
>>> +	}, {
>>> +		/* sentinel */
>>> +	}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, fsl_asrc_ids);
>>> +
>> move these ids after probe/remove... every driver follows same thing...
> Hmm.. fsl_asrc_ids is called in probe(), so it's probably not a good choice
> to put them after probe/remove. And actually not every driver does so.
> For example drivers/i2c/busses/i2c-s3c2410.c
>
> I think it should be okay to put here if it contains data.

You are using these ids in the probe .Tt should be above the probe() so
we can see of_match_device() directly...
and also one more thing that the interrupt handler also would be immediately
above the probe()

ex:
static irqreturn_t fsl_asrc_isr(int irq, void *dev_id)
{
...
}

device ids..

your_probe()
{
...
}

your_remove()
{
...
}

Now every driver that is coming following this style...

If your not using device ids in probe then it would be like

static irqreturn_t fsl_asrc_isr(int irq, void *dev_id)
{
...
}

your_probe()
{
...
}

your_remove()
{
...
}

device ids..

Thanks...

-- 
Regards,
Varka Bhadram.

