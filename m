Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaIMUFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:05:05 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49303 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaIMUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:05:03 -0400
Message-ID: <5414A36B.3000106@kernel.org>
Date: Sat, 13 Sep 2014 21:04:59 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: michals@xilinx.com, svemula@xilinx.com, anirudh@xilinx.com,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH] iio: adc: xilinx-xadc: assign auxiliary channels address
 correctly
References: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl> <54132C78.9000300@metafoo.de>
In-Reply-To: <54132C78.9000300@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 18:25, Lars-Peter Clausen wrote:
> On 09/11/2014 10:55 AM, Subbaraya Sundeep Bhatta wrote:
>> This patch fixes incorrect logic for assigning address
>> to auxiliary channels of xilinx xadc.
>>
>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Applied to the fixes-togreg branch of iio.git and flagged
for stable.

Thanks,

Jonathan
> 
>> ---
>>   drivers/iio/adc/xilinx-xadc-core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
>> index fd2745c..626b397 100644
>> --- a/drivers/iio/adc/xilinx-xadc-core.c
>> +++ b/drivers/iio/adc/xilinx-xadc-core.c
>> @@ -1126,7 +1126,7 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
>>                   chan->address = XADC_REG_VPVN;
>>               } else {
>>                   chan->scan_index = 15 + reg;
>> -                chan->scan_index = XADC_REG_VAUX(reg - 1);
>> +                chan->address = XADC_REG_VAUX(reg - 1);
>>               }
>>               num_channels++;
>>               chan++;
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
