Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaE1DHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:07:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:27871 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaE1DHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,924,1392192000"; 
   d="scan'208";a="545929212"
Message-ID: <538552D7.1000408@linux.intel.com>
Date: Wed, 28 May 2014 11:07:03 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3 1/4] mfd: intel_soc_pmic: Core driver
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com> <1401163576-14872-2-git-send-email-lejun.zhu@linux.intel.com> <20140527153541.GB4227@lee--X1>
In-Reply-To: <20140527153541.GB4227@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/27/2014 11:35 PM, Lee Jones wrote:
>> This patch provides the common code for the intel_soc_pmic MFD driver, such as read/write register and set up IRQ.
(...)
>> +/*
>> +* Set and clear multiple bits of a PMIC register
>> +*/
>> +int intel_soc_pmic_update(int reg, u8 val, u8 mask)
>> +{
>> +	int ret;
>> +	
>> +	mutex_lock(&pmic_lock);
>> +	
>> +	if (!pmic)
>> +		ret = -EIO;
>> +	else
>> +		ret = regmap_update_bits(pmic->regmap, reg, mask, val);
>> +	
>> +	mutex_unlock(&pmic_lock);
>> +	
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(intel_soc_pmic_update);
> 
> I'm really not a fan of all these pointless agregation call-backs.  I
> see them as unesersary overhead.  Just use the regmap API directly.

OK. I'll remove these wrappers from the MFD driver, seems no one likes
them...

I'll fix the patch set as you suggested and resubmit. Thank you for
reviewing this.

Best Regards
Lejun
