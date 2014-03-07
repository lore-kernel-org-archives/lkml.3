Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaCGPjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:39:07 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54626 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaCGPjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:39:04 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.134.110]
In-Reply-To: <5318922D.5090508@ti.com>
References: <1394111433.21007.2.camel@phoenix>
	<5318922D.5090508@ti.com>
Date: Fri, 7 Mar 2014 23:39:02 +0800
Message-ID: <CAFRkauC87Om2kqQDu1ZXkCWA0xqDkqv5ygzOPcexR3goQ3wvEA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: pbias: Convert to use regmap helper functions
From: Axel Lin <axel.lin@ingics.com>
To: Balaji T K <balajitk@ti.com>
Cc: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-06 23:20 GMT+08:00 Balaji T K <balajitk@ti.com>:
> On Thursday 06 March 2014 06:40 PM, Axel Lin wrote:
>>
>> This patch converts this driver to use the regmap helper functions
>> provided by
>> regulator core.
>>
>> This fixes a few issues in current implementation:
>>
>> 1) In original code, the set voltage does not check max_uV,
>>     which means if request max_uV < 1800000, it will still set the voltage
>>     to 1800000.
>>
>> 2) The is_enable implementation is wrong in some cases:
>>     e.g. for pbias_mmc_omap5: emable_mask is : BIT(27) | BIT(25) | BIT(26)
>>     However, pbias_regulator_enable() only sets BIT(26) | BIT(22) bits.
>>     So is_enable always return false in this case.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>> Hi Balaji,
>> I don't have this h/w, so please test if it works.
>
>
> Hi Axel,
>
> There were few issues when I tried using regmap helper,
> will check on this.

Hi Balaji,

I decide to break this patch to 3 pathes as below:

[PATCH 1/3] regulator: pbias: Fix is_enabled callback implementation
  This is pure bug fix for is_enabled logic

[PATCH 2/3] regulator: pbias: Convert to use regmap helper functions
  This simply convert to use regmap.

[PATCH 3/3] regulator: pbias: Convert to use
regulator_[enable|is_enabled]_regmap
  This one depends on commit ca5d1b3524b4d
 "regulator: helpers: Modify helpers enabling multi-bit control"
  which is currently only available on regulator tree.
  I sent it for review and test now, if it works, I'll resend it once
3.5-rc1 is release.

I'm sending the patches right away.

Regards,
Axel
