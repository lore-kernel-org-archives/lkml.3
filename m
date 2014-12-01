Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaLAMuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:50:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15588 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaLAMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:50:00 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f8-547c63f6c12b
Message-id: <547C63F4.4060203@samsung.com>
Date: Mon, 01 Dec 2014 13:49:56 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v8 09/14] mfd: max77693: adjust
 max77693_led_platform_data
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-10-git-send-email-j.anaszewski@samsung.com>
 <20141201113430.GC15845@x1>
In-reply-to: <20141201113430.GC15845@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xq7rfkmtCDDb/ZrG4te4cq8XGGetZ
	LY7unMhk8fHeP1aLs01v2C3ufz3KaHF51xw2i61v1jFa9GzYympx99RRNovdu56yWhx+085q
	cWb/SjaL092sDnweO2fdZfc4/HUhi8eda3vYPOadDPTYM/8Hq0ffllWMHs8+vmP2WLH6O7vH
	501yAZxRXDYpqTmZZalF+nYJXBn3p7WzFrTyViyc+ZqtgXEvVxcjJ4eEgInE9P5bjBC2mMSF
	e+vZQGwhgaWMEkcPGncxcgHZHxklVp/ezASS4BXQkji0/g+YzSKgKrHx1BR2EJtNwFDi54vX
	YHFRgQiJP6f3sULUC0r8mHyPpYuRg0NEQEXi3BtzkJnMAm+YJDZdmgDWKywQIrHrxEomiGXL
	GCVWPLjDApLgFNCQOPxnKpjNLGAm8ahlHTOELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVT
	S5MLipPScw31ihNzi0vz0vWS83M3MUIi6ssOxsXHrA4xCnAwKvHwXlhVHSLEmlhWXJl7iFGC
	g1lJhPetd02IEG9KYmVValF+fFFpTmrxIUYmDk6pBsaNGkf7MoPvlpoWXdmS5vh/otIeLelT
	76PXBhYcaLExil0WURJY7t3dcyNwu+8FO71N01ozvY45WP142FK+SiGwbHez3/UKO9/HzyQf
	ZDcfyjfSL+c+eP2J7MqtSRIrai3DXp5euI9TK6nq1Hmmmmtn9OIuf+86/W/Gsnp2OTf73K3z
	ww7/+6bEUpyRaKjFXFScCAA/pTRmhgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for the review.

On 12/01/2014 12:34 PM, Lee Jones wrote:
> On Fri, 28 Nov 2014, Jacek Anaszewski wrote:
>
>> Add "label" array for Device Tree strings with
>> the name of a LED device and make flash_timeout
>> a two element array, for caching the sub-led
>> related flash timeout.
>
> <------------------------------------------------------------------------->
>
> Please use all of the 75 char buffer.

OK.

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: SangYoung Son <hello.son@smasung.com>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> ---
>>   include/linux/mfd/max77693.h |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
>> index f0b6585..30fa19ea 100644
>> --- a/include/linux/mfd/max77693.h
>> +++ b/include/linux/mfd/max77693.h
>> @@ -88,14 +88,15 @@ enum max77693_led_boost_mode {
>>   };
>>
>>   struct max77693_led_platform_data {
>> +	const char *label[2];
>>   	u32 fleds[2];
>>   	u32 iout_torch[2];
>>   	u32 iout_flash[2];
>>   	u32 trigger[2];
>>   	u32 trigger_type[2];
>> +	u32 flash_timeout[2];
>>   	u32 num_leds;
>>   	u32 boost_mode;
>> -	u32 flash_timeout;
>>   	u32 boost_vout;
>>   	u32 low_vsys;
>>   };
>
> I'm guessing this will effect the other patches in the set?
>

max77692 flash driver depends on it and it has to be
in synch with the related DT bindings patch.

Best Regards,
Jacek Anaszewski
