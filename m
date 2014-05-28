Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaE1AzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:55:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:22023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaE1AzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,923,1392192000"; 
   d="scan'208";a="545868566"
Message-ID: <538533EF.6080101@linux.intel.com>
Date: Wed, 28 May 2014 08:55:11 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com> <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com> <20140523174925.GH22111@sirena.org.uk> <5382D8A7.7010704@linux.intel.com> <20140526145127.GM22111@sirena.org.uk> <5383E0FA.5060509@linux.intel.com> <20140527112024.GS12304@sirena.org.uk>
In-Reply-To: <20140527112024.GS12304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 5/27/2014 7:20 PM, Mark Brown wrote:
> On Tue, May 27, 2014 at 08:48:58AM +0800, Zhu, Lejun wrote:
>> On 5/26/2014 10:51 PM, Mark Brown wrote:
> 
>>>> We created these names to hide the implementation of how read/write is
>>>> done from other platform specific patches interacting with this driver.
>>>> So when we change the implementation, e.g. from I2C read/write to
>>>> regmap, we don't have to touch all these patches.
> 
>>> This sort of HAL is frowned upon in the upstream kernel.
> 
>> We want to do what other MFD drivers' been doing, and make it easier for
>> the callers. A couple of similar examples are intel_msic_reg_read() and
>> lp3943_read_byte(). We want to do the same with intel_soc_pmic_readb(),
>> and I don't think it's too odd.
> 
> The odd and problematic bit is the global variable part of things -
> these wrappers are usually just doing lookup of the underlying I/O
> handle in the struct for the device and can be implemented as static
> inlines in the header.
> 

Oh I see. Sorry I missed your point. So you are saying "int
intel_soc_pmic_readb(int reg)" is bad, but if I have:

int intel_soc_pmic_readb(struct intel_soc_pmic *pmic, int reg)
{
	int ret;
	unsigned int val;

	ret = regmap_read(pmic->regmap, reg, &val);
	if (!ret)
		ret = val;

	return ret;
}

And have the caller (device or core) look up and pass *pmic in, this
will be OK?

Best Regards
Lejun
