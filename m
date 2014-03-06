Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCFJtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:49:01 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35418 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCFJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:48:58 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-54-53184488816c
Message-id: <1394099334.25853.1.camel@AMDC1943>
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Thu, 06 Mar 2014 10:48:54 +0100
In-reply-to: <20140306093826.GO13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
 <20140306093826.GO13126@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xq7odLhLBBif+8FpsnLGe1WLqwyds
	Fmeb3rBb3P96lNHi25UOJovLu+awWcw4v4/JYu2Ru+wWJ//0Mlqc7ma1uLjiC5PF+hmvWSzm
	TH/H5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfyc
	epa54CRHxcrXlg2MN9i6GDk5JARMJDYfboSyxSQu3FsPZHNxCAksZZRY/vgiC4TzmVFi6/O/
	zCBVvAL6EleX3WYFsYUFAiTWr/kEFmcTMJbYvHwJ2CQRAWWJq9/3gjUzC7xilniwexJYgkVA
	VWLJtdVANgcHJ1DDhJWSEAvWMEoc7TgDNohZQF1i0rxFzBAnKUnsbu9kh4jLS2xe8xbqCEGJ
	H5PvsUxgFJiFpGUWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJlC87GBcf
	szrEKMDBqMTDu8FPPFiINbGsuDL3EKMEB7OSCO8WQ4lgId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYxl+/6uVfjtK63eIPol7nPyxQa5b8LGDBta1RequHxteJ1w83/Juyemu77ptieu21WoEPNB
	puj2SstlRfFVU+ILXPZtzNSIlLrJ/dBbXJDpYF/jRnPRrmm5bb339p3qWq95J2ljL78IXw6L
	xSqGXfEiXPx/c2Wqv1zd37W9g9mu9yObuXjoeiWW4oxEQy3mouJEADByKOdyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 17:38 +0800, Mark Brown wrote:
> On Wed, Mar 05, 2014 at 10:22:52AM +0100, Krzysztof Kozlowski wrote:
> 
> > +	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &data);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/*
> > +	 * Don't enable suspend mode if regulator is already disabled because
> > +	 * this would effectively for a short time turn on the regulator after
> > +	 * resuming.
> > +	 */
> > +	if (!(data & rdev->desc->enable_mask))
> > +		return 0;
> > +
> > +	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> > +			rdev->desc->enable_mask, S2MPS14_ENABLE_SUSPEND);
> > +}
> 
> What happens if the regulator gets enabled between this being called
> and the device suspending?  I'd expect this to be storing the state and
> then changing what gets written during enable and disable operations (if
> the hardware does what I think it does).

Hmmm... you're right. I'll fix this.

Anyway can you look at other two patches and apply them if they are OK?
They don't depend on this.

Best regards,
Krzysztof

