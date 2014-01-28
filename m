Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaA1HQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:16:05 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:63749 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaA1HQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:16:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140128063308.GA5965@core.coreip.homeip.net>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
	<20140128063308.GA5965@core.coreip.homeip.net>
Date: Tue, 28 Jan 2014 12:46:01 +0530
Message-ID: <CAKDJKT5COnY=i4Dd-P8_eMoWBU+ShqVKVhoVGBk1qWxffe+wMg@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thank you for your review.

On Tue, Jan 28, 2014 at 12:03 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Manish,
>
> On Tue, Jan 28, 2014 at 08:42:00AM +0530, Manish Badarkhe wrote:
>> Update the code to use devm_* API so that driver core will manage
>> resources.
>>
>> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
>> ---
>> Changes since V1:
>> 1. Updated driver to use "devm_kzalloc" to "kstrdup".
>> 2. Updated commit message.
>>
>> Not tested on any board.
>>
>> :100644 100644 5ea64b9... e9763a4... M        drivers/regulator/fixed.c
>>  drivers/regulator/fixed.c |   42 ++++++++++++------------------------------
>>  1 file changed, 12 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
>> index 5ea64b9..e9763a4 100644
>> --- a/drivers/regulator/fixed.c
>> +++ b/drivers/regulator/fixed.c
>> @@ -132,15 +132,15 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
>>                              GFP_KERNEL);
>>       if (drvdata == NULL) {
>>               dev_err(&pdev->dev, "Failed to allocate device data\n");
>> -             ret = -ENOMEM;
>> -             goto err;
>> +             return -ENOMEM;
>>       }
>>
>> -     drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
>> +     drvdata->desc.name = devm_kzalloc(&pdev->dev,
>> +                                       strlen(config->supply_name) + 1,
>> +                                       GFP_KERNEL);
>>       if (drvdata->desc.name == NULL) {
>>               dev_err(&pdev->dev, "Failed to allocate supply name\n");
>> -             ret = -ENOMEM;
>> -             goto err;
>> +             return -ENOMEM;
>>       }
>
> Umm, I am fairly certain that devm_kzalloc() can't be used as a
> substitute for kstrdup, at least not without accompanying memcpy.

Yes, I have provided allocation but it should be followed with assignment.
Can I modify like this,

+     drvdata->desc.name = devm_kzalloc(&pdev->dev,
+                                       strlen(config->supply_name) + 1,
+                                       GFP_KERNEL);
+     if (drvdata->desc.name)
+     sprintf(drvdata->desc.name, "%s", config->supply_name);

Thanks
Manish Badakhe
