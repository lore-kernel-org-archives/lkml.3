Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaE0AtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:49:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:10797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaE0AtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,915,1392192000"; 
   d="scan'208";a="437110103"
Message-ID: <5383E0FA.5060509@linux.intel.com>
Date: Tue, 27 May 2014 08:48:58 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com> <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com> <20140523174925.GH22111@sirena.org.uk> <5382D8A7.7010704@linux.intel.com> <20140526145127.GM22111@sirena.org.uk>
In-Reply-To: <20140526145127.GM22111@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/26/2014 10:51 PM, Mark Brown wrote:
> On Mon, May 26, 2014 at 02:01:11PM +0800, Zhu, Lejun wrote:
>> On 5/24/2014 1:49 AM, Mark Brown wrote:
> 
>>> There should also be no need to add extra locking around regmap calls,
>>> the regmap API has locking as standard.
> 
>> Actually it also protects the pmic variable, so it won't be set to NULL
>> while there's ongoing read/write.
> 
> Righ, but there is no clear need for the pmic variable to exist in the
> first place.
>
>>> It's also not clear why this API exists at all, surely all the
>>> interaction with the device happens from the core or function drivers
>>> for the device which ought to be able to get a direct reference to the
>>> regmap anyway and only be instantiated when one is present.
> 
>> We created these names to hide the implementation of how read/write is
>> done from other platform specific patches interacting with this driver.
>> So when we change the implementation, e.g. from I2C read/write to
>> regmap, we don't have to touch all these patches.
> 
> This sort of HAL is frowned upon in the upstream kernel.

We want to do what other MFD drivers' been doing, and make it easier for
the callers. A couple of similar examples are intel_msic_reg_read() and
lp3943_read_byte(). We want to do the same with intel_soc_pmic_readb(),
and I don't think it's too odd.

Best Regards
Lejun


