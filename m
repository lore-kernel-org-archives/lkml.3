Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab3IFION (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:14:13 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:54407 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3IFIOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130906070248.GB32654@lee--X1>
References: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
	<20130906070248.GB32654@lee--X1>
Date: Fri, 6 Sep 2013 13:44:09 +0530
Message-ID: <CAK9yfHwA4Nnw6hKvKaVByFOwfMR84j2BtwBwYfuYHWXnXo_T0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ab8500-charger: Check return value of regulator_enable
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, anton@enomsg.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 September 2013 12:32, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 06 Sep 2013, Sachin Kamat wrote:
>
>> Check the return value of regulator_enable to silence the following
>> type of warnings:
>> drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
>> of ‘regulator_enable’, declared with attribute warn_unused_result
>> [-Wunused-result]
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>> Compile tested.
>> Changes since v1:
>>  * converted dev_err and return to dev_warn as suggested by Lee Jones.
>> ---
>>  drivers/power/ab8500_charger.c |   20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
>> index a4c4a10..0d355a9 100644
>> --- a/drivers/power/ab8500_charger.c
>> +++ b/drivers/power/ab8500_charger.c
>> @@ -1387,8 +1387,14 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
>>                * the GPADC module independant of the AB8500 chargers
>>                */
>>               if (!di->vddadc_en_ac) {
>> -                     regulator_enable(di->regu);
>> -                     di->vddadc_en_ac = true;
>> +                     ret = regulator_enable(di->regu);
>> +                     if (ret) {
>> +                             dev_warn(di->dev,
>> +                                     "Failed to enable regulator\n");
>> +                             di->vddadc_en_ac = false;
>
> Isn't di->vddadc_en_ac already false?
>
> Or you wouldn't have made it into the if().

Yes you are right. This and other similar statements are redundant.

-- 
With warm regards,
Sachin
