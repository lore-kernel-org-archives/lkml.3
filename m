Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaCXIMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:12:10 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.146]:12679 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbaCXIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:12:06 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-179.messagelabs.com!1395648723!26694764!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        "David Dajun Chen" <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [RFC V1 1/3] hwmon: da9063: HWMON driver
Thread-Topic: [RFC V1 1/3] hwmon: da9063: HWMON driver
Thread-Index: AQHPRttXGKX6/plr5kirxkYUlEAgKprv3kKAgAABUKA=
Date: Mon, 24 Mar 2014 08:12:02 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7A2AFC31D@SW-EX-MBX01.diasemi.com>
References: <cover.1395607051.git.stwiss.opensource@diasemi.com>
 <420d4f5c8436a66b511693531cfeda131258ce69.1395607051.git.stwiss.opensource@diasemi.com>
 <20140324075221.GF8541@lee--X1>
In-Reply-To: <20140324075221.GF8541@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2O8CJEo013618

Hi Lee,
Thank you for the fast reply.

On 24 March 2014 07:52 Lee Jones wrote,
>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> Add the HWMON driver for DA9063
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> ---
>>
>>  drivers/hwmon/Kconfig                |   10 +
>>  drivers/hwmon/Makefile               |    1 +
>>  drivers/hwmon/da9063-hwmon.c         |  456
>++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/da9063/registers.h |   34 +++
>
>I'd prefer to see all values in hex, but this probably a preference
>thing rather than something which would prevent acceptance.
>
>For the MFD header changes:
>  Acked-by: Lee Jones <lee.jones@linaro.org>
>
Thanks for the Ack.

<snip>
> +#define DA9063_ADC_RES	(1 << (DA9063_ADC_RES_L_BITS + DA9063_ADC_RES_M_BITS))
> +#define DA9063_ADC_MAX	(DA9063_ADC_RES - 1)
>> +#define DA9063_2V5	2500
>> +#define DA9063_5V0	5000
>> +#define DA9063_5V5	5500
>> +#define DA9063_TJUNC_M	-420
>> +#define DA9063_TJUNC_C	-812
>> +#define DA9063_VBBAT_M	2048

I am using these defines as part of the base-10 calculations in the conversion
routines for voltage and temperature.
I guess they do look weird .. and looking at it, I have mixed  division by 1024
as a right shift 10 in the TJUNC calculation.

I will re-format that part and put a comment in the defines to explain.
Thanks.

<snip>
>> +	case DA9063_CHAN_ADCIN1:
>> +	case DA9063_CHAN_ADCIN2:
>> +	case DA9063_CHAN_ADCIN3:
>> +		val = (DA9063_2V5 * val) / DA9063_ADC_MAX;
>> +		break;
>> +	case DA9063_CHAN_VSYS:
>> +		val = ((DA9063_5V5 - DA9063_2V5) * val) / DA9063_ADC_MAX +
>> +			DA9063_2V5;
>> +		break;
>> +	case DA9063_CHAN_TJUNC:
>> +		val -= hwmon->tjunc_offset;
>> +		val = (DA9063_TJUNC_M * (val + DA9063_TJUNC_C)) >> 10;
>> +		break;
>> +	case DA9063_CHAN_VBBAT:
>> +		val = (DA9063_5V0 * val) / DA9063_ADC_MAX;
>> +		break;

<snip>
>
>--
>Lee Jones
>Linaro STMicroelectronics Landing Team Lead
>Linaro.org â”‚ Open source software for ARM SoCs
>Follow Linaro: Facebook | Twitter | Blog

Regards,
Steve
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
