Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBNOxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:53:20 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60551 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBNOxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:53:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140214134815.GD13293@lee--X1>
References: <1392383861-14169-1-git-send-email-marek@goldelico.com>
	<20140214134815.GD13293@lee--X1>
Date: Fri, 14 Feb 2014 15:53:18 +0100
Message-ID: <CAAfyv36FH364OPnktx_Qh6sUfwYe7hynqrc3Xs_tY4gPXqQWvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add devicetree support.
From: Belisko Marek <marek.belisko@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 2:48 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  .../devicetree/bindings/mfd/twl4030-madc.txt       | 18 +++++++++++++
>>  drivers/mfd/twl4030-madc.c                         | 31
>> ++++++++++++++++++++--
>
> Please separate these into different patches.
OK.
>
>>  2 files changed, 47 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-madc.txt
>
> <snip>
>
>> +++ b/drivers/mfd/twl4030-madc.c
>> @@ -695,6 +695,29 @@ static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_OF
>
> I believe we're heading for a more:
>
>   if (IS_ENABLED(CONFIG_OF))
>
> ... approach. I won't enforce it, but please consider using it.
OK I'll use it in next version.
>
>> +static struct twl4030_madc_platform_data *
>> +     twl4030_madc_of_parse(struct platform_device *pdev)
>> +{
>> +     struct twl4030_madc_platform_data *pdata;
>> +
>> +     pdata = devm_kzalloc(&pdev->dev,
>> +                     sizeof(struct twl4030_madc_platform_data), GFP_KERNEL);
>
> s/struct twl4030_madc_platform_data/*pdata/
Right typo.
>
>> +     if (!pdata)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     pdata->irq_line = platform_get_irq(pdev, 0);
>
> Why weren't 'resources' used in the original implementation?
Not sure I'm not an author :). It's passed in platform data.
>
>> +     return pdata;
>> +}
>> +
>> +static const struct of_device_id twl4030_madc_dt_match_table[] = {
>> +     { .compatible = "ti,twl4030-madc" },
>> +     {},
>> +};
>> +
>> +#endif
>> +
>>  /*
>>   * Initialize MADC and request for threaded irq
>>   */
>> @@ -706,8 +729,11 @@ static int twl4030_madc_probe(struct platform_device *pdev)
>>       u8 regval;
>>
>>       if (!pdata) {
>> -             dev_err(&pdev->dev, "platform_data not available\n");
>> -             return -EINVAL;
>> +             pdata = twl4030_madc_of_parse(pdev);
>> +             if (!pdata) {
>
> And if you received -ENOMEM?
Hmm right. I'll fix that.
>
>> +                     dev_err(&pdev->dev, "platform_data not available\n");
>> +                     return -EINVAL;
>> +             }
>>       }
>>       madc = kzalloc(sizeof(*madc), GFP_KERNEL);
>>       if (!madc)
>> @@ -807,6 +833,7 @@ static struct platform_driver twl4030_madc_driver = {
>>       .driver = {
>>                  .name = "twl4030_madc",
>>                  .owner = THIS_MODULE,
>> +                .of_match_table = of_match_ptr(twl4030_madc_dt_match_table),
>>                  },
>>  };
>>
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
