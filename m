Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3CAM4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:56:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3212 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3CAM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:56:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Mar 2013 04:56:40 -0800
Message-ID: <5130A53C.1000600@nvidia.com>
Date: Fri, 1 Mar 2013 18:25:24 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com> <20130301124350.GA25302@opensource.wolfsonmicro.com>
In-Reply-To: <20130301124350.GA25302@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013 06:13 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, Mar 01, 2013 at 06:04:56PM +0530, Laxman Dewangan wrote:
>
>> Currently driver sets the irq type to IRQF_TRIGGER_LOW which is
>> causing interrupt registration failure in ARM based SoCs as:
>> [    0.208479] genirq: Setting trigger mode 8 for irq 118 failed (gic_set_type+0x0/0xf0)
>> [    0.208513] dummy 0-0059: Failed to request IRQ 118: -22
> This can't be a generic problem on ARM systems, I'm pretty sure the
> primary users of palmas would've noticed, this is more of a new feature
> isn't it?

I think it is tested with eval board and connected to gpio interrupt and 
hence it is not noticed.


>
>> +	if (ret < 0) {
>> +		dev_err(palmas->dev, "POLARITY_CTRL write failed: %d\n", ret);
>> +		goto err;
>> +	}
> Isn't there a read/modify/write call for palmas?

Yaah, there is call but forget as I took this fix from my downstream code.
I will respin the next patch.

