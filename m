Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaAHJVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:21:22 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:45817 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaAHJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:21:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140108090208.GD19974@lee--X1>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
	<20140108090208.GD19974@lee--X1>
Date: Wed, 8 Jan 2014 14:51:15 +0530
Message-ID: <CAK9yfHyDNfRcn4J6N5u=CbVHsRqCp5LSgUavsD1p7Gjp+m9dfQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: Add support for S2MPA01 device
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, robh+dt@kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for the review.

On 8 January 2014 14:32, Lee Jones <lee.jones@linaro.org> wrote:
>> Add the necessary entries required for S2MPA01 multi-function
>> device. While at it also convert whitespaces to tabs in core.h.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/mfd/sec-core.c              |   39 +++++++
>>  include/linux/mfd/samsung/core.h    |   16 ++-
>>  include/linux/mfd/samsung/irq.h     |   50 +++++++++
>>  include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
>>  4 files changed, 292 insertions(+), 5 deletions(-)
>>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index a139798b8065..d2e890d50a36 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/mfd/samsung/core.h>
>>  #include <linux/mfd/samsung/irq.h>
>>  #include <linux/mfd/samsung/rtc.h>
>> +#include <linux/mfd/samsung/s2mpa01.h>
>>  #include <linux/mfd/samsung/s2mps11.h>
>>  #include <linux/mfd/samsung/s5m8763.h>
>>  #include <linux/mfd/samsung/s5m8767.h>
>> @@ -69,6 +70,13 @@ static const struct mfd_cell s2mps11_devs[] = {
>>       }
>>  };
>>
>> +static const struct mfd_cell s2mpa01_devs[] = {
>> +     {
>> +             .name = "s2mpa01-pmic",
>> +     },
>> +};
>> +
>> +
>
> Extra '/n' here.

Right. Will remove it.

>
>>  #ifdef CONFIG_OF
>>  static struct of_device_id sec_dt_match[] = {
>>       {       .compatible = "samsung,s5m8767-pmic",
>> @@ -77,10 +85,25 @@ static struct of_device_id sec_dt_match[] = {
>>       {       .compatible = "samsung,s2mps11-pmic",
>>               .data = (void *)S2MPS11X,
>>       },
>> +     {       .compatible = "samsung,s2mpa01-pmic",
>> +             .data = (void *)S2MPA01,
>> +     },
>
> Can you use the same format at the rest of the file.
>
> I'm happy for you to fix the entire struct in this patch.
>
> Rest of the file uses overlapping format:

Sure. I formatted it as per the current structure without noticing the others.
Will change it.

>
>         }, {
>                 .compatible = "samsung,s2mpa01-pmic",
>         },
>
>
> <snip>
>
>> @@ -92,7 +93,7 @@ struct sec_platform_data {
>>       int                             buck3_default_idx;
>>       int                             buck4_default_idx;
>>
>> -     int                             buck_ramp_delay;
>> +     int                             buck_ramp_delay;
>
> What's this? Are you fixing (or breaking) white space here?

I didn't get you. I have converted spaces to tabs here. See some problem?


-- 
With warm regards,
Sachin
