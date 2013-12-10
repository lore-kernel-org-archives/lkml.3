Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3LJJiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:38:55 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37620 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LJJiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:38:51 -0500
MIME-Version: 1.0
In-Reply-To: <1386667806.4008.2.camel@AMDC1943>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
	<CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
	<1386667806.4008.2.camel@AMDC1943>
Date: Tue, 10 Dec 2013 15:08:51 +0530
Message-ID: <CAK9yfHyTHwC32aYsN9YQgeenY_EtrhVVDjndUyQO+ePk5xCTiQ@mail.gmail.com>
Subject: Re: [TRIVIAL PATCH 1/2] regulator: s5m8767: Define symbol for buck
 control mask
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Kosina <trivial@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2013 15:00, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> On Tue, 2013-12-10 at 14:48 +0530, Sachin Kamat wrote:
>> Hi Krzysztof,
>>
>> On 10 December 2013 14:39, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
>>
>> >  static int s5m8767_reg_disable(struct regulator_dev *rdev)
>> >  {
>> >         struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
>> >         int ret, reg;
>> > -       int  mask = 0xc0, enable_ctrl;
>> > +       int mask = S5M8767_ENCTRL_MASK, enable_ctrl;
>>
>> Couldn't we get rid of this mask variable here too?
>>
>> Otherwise the patch looks good to me.
>
> Not in this patch because it leads to warning:
>
> drivers/regulator/s5m8767.c: In function ‘s5m8767_reg_disable’:
> drivers/regulator/s5m8767.c:259:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> drivers/regulator/s5m8767.c:253:6: warning: unused variable ‘mask’ [-Wunused-variable]

I see.

>
> I plan to remove the sec_reg_*() helpers because they are confusing
> and error-prone (mixing u8 and unsigned int). After using standard regmap
> API this "mask" variable could be removed.

Sounds good.

For the subject patch,
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
