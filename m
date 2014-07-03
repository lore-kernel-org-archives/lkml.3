Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGCTq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:46:58 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59237 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaGCTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140703084108.GA3012@katana>
References: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<009301cf93f6$f938a270$eba9e750$%han@samsung.com>
	<CAFo99gY2qEEqwJgu-NQryAe2=o5AsDjL+SFaau6BA7CBMH8Xkg@mail.gmail.com>
	<003601cf9660$83368990$89a39cb0$%han@samsung.com>
	<20140703084108.GA3012@katana>
Date: Thu, 3 Jul 2014 21:46:55 +0200
Message-ID: <CAFo99ga2QVU2L_8etWMKaP2KNM_dxaaeXG-S8p9ksqpLTmAiqQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: busses: i2c-pxa.c: Fix for possible null pointer dereferenc
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jingoo Han <jg1.han@samsung.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-03 10:41 GMT+02:00 Wolfram Sang <wsa@the-dreams.de>:
> Hi Rickard, hi Jingoo,
>
>> I also trust Wolfram. He is one of the most important and active
>> person for Linux kernel.
>
> Oh, thanks. I'm flattered :)
>
>> Wolfram may mean devm_ioremap_resource(), not devm_ioremap().
>
> Yes, you are right. Sorry for missing this detail when suggesting an
> example to convert to devm_*. devm_ioremap_resource should be favoured
> over devm_ioremap.
>
>> 1. devm_ioremap_resource(): IS_ERR() can be used.
>>
>>       dev->virtbase = devm_ioremap_resource(&adev->dev, res));
>>       if (IS_ERR(dev->virtbase)) {
>
> This is correct and preferred.
>
> BTW I don't care much about splitting up the patch as long as the commit
> message says that the original bug is a motivation to swicth to devm_*.
>
> Thanks Rickard for picking up the task, and thanks Jingoo for reviewing.
>
> Kind regards,
>
>    Wolfram

Hi

Then I changed like:

-       i2c->reg_base = devm_ioremap(&dev->dev, res->start, resource_size(res));
+       i2c->reg_base = devm_ioremap_resource(&adev->dev, res));


I like Wolfram see no point in doing this patch in two steps, as none
of patch 1, which would be the solution to the original problem would
be includid in patch 2.

I will send a V3 of this patch in a moment...


Thanks to everyone who helped out :-)


Kind regards
Rickard Strandqvist
