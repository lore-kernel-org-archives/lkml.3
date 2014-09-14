Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaINIaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:30:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55434 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaINIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <5414A36B.3000106@kernel.org>
References: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl>
	<54132C78.9000300@metafoo.de>
	<5414A36B.3000106@kernel.org>
Date: Sun, 14 Sep 2014 14:00:10 +0530
Message-ID: <CALHRZuo=QSpKdn2R6g90Roeu1pK_NFxhiNELPuTpsayWGm+Ldg@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: xilinx-xadc: assign auxiliary channels address correctly
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>, svemula@xilinx.com,
        anirudh@xilinx.com, Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Lars and Jonathan,

Sundeep.

On Sun, Sep 14, 2014 at 1:34 AM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 12/09/14 18:25, Lars-Peter Clausen wrote:
>> On 09/11/2014 10:55 AM, Subbaraya Sundeep Bhatta wrote:
>>> This patch fixes incorrect logic for assigning address
>>> to auxiliary channels of xilinx xadc.
>>>
>>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>>
>> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> Applied to the fixes-togreg branch of iio.git and flagged
> for stable.
>
> Thanks,
>
> Jonathan
>>
>>> ---
>>>   drivers/iio/adc/xilinx-xadc-core.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
>>> index fd2745c..626b397 100644
>>> --- a/drivers/iio/adc/xilinx-xadc-core.c
>>> +++ b/drivers/iio/adc/xilinx-xadc-core.c
>>> @@ -1126,7 +1126,7 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
>>>                   chan->address = XADC_REG_VPVN;
>>>               } else {
>>>                   chan->scan_index = 15 + reg;
>>> -                chan->scan_index = XADC_REG_VAUX(reg - 1);
>>> +                chan->address = XADC_REG_VAUX(reg - 1);
>>>               }
>>>               num_channels++;
>>>               chan++;
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
