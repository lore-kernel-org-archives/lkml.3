Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3DPP1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:27:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48701 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3DPP1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:27:39 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.103.40]
In-Reply-To: <516D3F2F.8080905@stericsson.com>
References: <1365598464.24689.1.camel@phoenix>
	<516D3F2F.8080905@stericsson.com>
Date: Tue, 16 Apr 2013 23:27:38 +0800
Message-ID: <CAFRkauCQgHEs0P7nOGNkPuzZYpEPYykX20jD3agpFZWTAhG3=A@mail.gmail.com>
Subject: Re: [RFT][PATCH 1/3] regulator: ab8500-ext: Don't allow set idle mode
 if info->cfg->hwreq is set
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/16 Bengt Jönsson <bengt.g.jonsson@stericsson.com>:
> On 04/10/2013 02:54 PM, Axel Lin wrote:
>>
>> The regulator always on with high power mode if info->cfg->hwreq is set.
>>
>> If we allow set idle mode when info->cfg->hwreq is set, get_mode() returns
>> REGULATOR_MODE_IDLE but the regulator actually is in REGULATOR_MODE_NORMAL
>> mode.
>> This patch avoid inconsistent status return by get_mode().
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>z
>>
>> ---
>>   drivers/regulator/ab8500-ext.c |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/regulator/ab8500-ext.c
>> b/drivers/regulator/ab8500-ext.c
>> index 9aee21c..f0a1bbf 100644
>> --- a/drivers/regulator/ab8500-ext.c
>> +++ b/drivers/regulator/ab8500-ext.c
>> @@ -192,6 +192,10 @@ static int ab8500_ext_regulator_set_mode(struct
>> regulator_dev *rdev,
>>                 info->update_val = info->update_val_hp;
>>                 break;
>>         case REGULATOR_MODE_IDLE:
>> +               /* Always on with high power mode if info->cfg->hwreq is
>> set */
>> +               if (info->cfg && info->cfg->hwreq)
>> +                       return -EINVAL;
>> +
>>                 info->update_val = info->update_val_lp;
>>                 break;
>>
>
> I prefer to have info->update_val updated to reflect requested mode (in
> get_mode) instead of returning -EINVAL. This is how I interpret Mark's
> comment on the other patch ([PATCH] regulator: ab8500: Fix get_mode for
> shared mode regulators).Otherwise, the patch should work fine.

Well, I drop this path and send v2 for other patches now.

Thanks for the review,
Axel
