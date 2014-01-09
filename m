Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaAIFJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:09:37 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42761 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaAIFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140108123002.GY31886@sirena.org.uk>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
	<1389162390-4582-2-git-send-email-sachin.kamat@linaro.org>
	<20140108123002.GY31886@sirena.org.uk>
Date: Thu, 9 Jan 2014 10:39:34 +0530
Message-ID: <CAK9yfHwZN93T=Cs0jZ=ce6PBnjoFM6OcpC2cT1TCZVjHLBEJ=Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: Add support for S2MPA01 regulator
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for reviewing.

On 8 January 2014 18:00, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Jan 08, 2014 at 11:56:29AM +0530, Sachin Kamat wrote:
>
>> +     if (!iodev->dev->of_node) {
>> +             if (pdata) {
>> +                     goto common_reg;
>> +             } else {
>> +                     dev_err(pdev->dev.parent,
>> +                             "Platform data or DT node not supplied\n");
>> +                     return -ENODEV;
>> +             }
>> +     }
>
> The driver shouldn't need these to probe, it should be able to start in
> read only mode with no configuration.

OK.

>
>> +static int __init s2mpa01_pmic_init(void)
>> +{
>> +     return platform_driver_register(&s2mpa01_pmic_driver);
>> +}
>> +subsys_initcall(s2mpa01_pmic_init);
>
> module_platform_driver().

Just a small doubt here. Wouldn't changing this from subsys init to module init
cause problems to devices like mmc which would want the regulators available
(where they are not already enabled by the boot loader)?

-- 
With warm regards,
Sachin
