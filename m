Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaI3Ga3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:30:29 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:35652 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbaI3Ga1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:30:27 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Message-ID: <542A4D80.60101@smartplayin.com>
Date: Tue, 30 Sep 2014 11:58:16 +0530
From: Kiran Padwal <kiran.padwal@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [RFC 4/7] soc: qcom: Add Shared Memory Manager driver
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-5-git-send-email-bjorn.andersson@sonymobile.com> <542A4AEF.2030402@smartplayin.com>
In-Reply-To: <542A4AEF.2030402@smartplayin.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 30 September 2014 11:47 AM, Kiran Padwal wrote:
> Hi Bjorn,
> 
> On Tuesday 30 September 2014 06:04 AM, Bjorn Andersson wrote:
>> The Shared Memory Manager driver implements an interface for allocating
>> and accessing items in the memory area shared among all of the
>> processors in a Qualcomm platform.
>>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> ---
> 
> <snip>
> 
>> +
>> +static int qcom_smem_probe(struct platform_device *pdev)
>> +{
>> +	struct qcom_smem *smem;
>> +	struct resource *res;
>> +	size_t array_size;
>> +	int num_regions = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < pdev->num_resources; i++) {
>> +		res = &pdev->resource[i];
>> +
>> +		if (resource_type(res) == IORESOURCE_MEM)
>> +			num_regions++;
>> +	}
>> +
>> +	if (num_regions == 0) {
>> +		dev_err(&pdev->dev, "no smem regions specified\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	array_size = num_regions * sizeof(struct smem_region);
>> +	smem = devm_kzalloc(&pdev->dev, sizeof(*smem) + array_size, GFP_KERNEL);
>> +	if (!smem)
>> +		return -ENOMEM;
>> +
>> +	smem->dev = &pdev->dev;
>> +	smem->hwlock = of_hwspin_lock_request(pdev->dev.of_node, NULL);
> 
> Compilation breaks while I try to compile with this patch.
> Do I missing anything? Below is the error I am getting,
> 
> drivers/soc/qcom/qcom_smem.c: In function ‘qcom_smem_probe’:
> drivers/soc/qcom/qcom_smem.c:274:2: error: implicit declaration of function ‘of_hwspin_lock_request’ [-Werror=implicit-function-declaration]
>   smem->hwlock = of_hwspin_lock_request(pdev->dev.of_node, NULL)

I am sorry I missed the note in commit message of this patch. I did look for any such note in cover letter 
and also googled around for any change to find this function.
Could not find and hence posted comment. Please ignore.

> 
> Thanks,
> --Kiran
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

