Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbbATNBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:01:43 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40891 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbATNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:01:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e7-54be51b5791e
Message-id: <54BE51B2.8040209@samsung.com>
Date: Tue, 20 Jan 2015 14:01:38 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
 <20150120111719.GF13701@x1>
In-reply-to: <20150120111719.GF13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xK7pbA/eFGLw6yG2xccZ6VoujOycy
	WVz/8pzVYv6Rc6wWZ5vesFvc/3qU0eLyrjlsFlvfrGO06NmwldXi7qmjbBa7dz1ltTj8pp3V
	4sz+lWwOvB47Z91l9zj8dSGLx51re9g89sz/werRt2UVo8eK1d/ZPT5vkgtgj+KySUnNySxL
	LdK3S+DKeD3hAFtBJ0/FpDX6DYyfOLsYOTgkBEwk9u6V6GLkBDLFJC7cW8/WxcjFISSwlFHi
	5tFWJgjnI6PEr2Xb2EGqeAW0JLpufGIDsVkEVCWu7bjNCmKzCRhK/HzxmgnEFhWIkPhzeh8r
	RL2gxI/J91hAlokIqEice2MOEmYW2MUkse+4BogtLJAscf3NFKhdixklJp/bwAyS4BTQkJg6
	4ygLRIOZxKOWdcwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7N
	S9dLzs/dxAiJma87GJceszrEKMDBqMTDe8J5b4gQa2JZcWXuIUYJDmYlEd6z5vtChHhTEiur
	Uovy44tKc1KLDzEycXBKNTDOserZ6+YjsXUdZ9XTP6eZW61v2tycuDG54O/CO75PG26Jbz2f
	sYjb/vPJnTHiiumbzIMvFf048473wNZZQUZLD5d2hffH7ChSNpF49WL9vT4GBZ+l91oDbDr7
	/i04Wbde5ob1vUtWE9a13l+gd6dvV/r3MpmGe1esFDpmrClst9PSTtD3qcpXYinOSDTUYi4q
	TgQATYIHxXcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 12:17 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
>> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
>> from leds-max77693 driver.
>
> Off-by-one ay?  Wasn't the original code tested?

The driver using these macros is a part of LED / flash API integration
patch series, which still undergoes modifications and it hasn't
reached its final state yet, as there are many things to discuss.

>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   include/linux/mfd/max77693-private.h |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
>> index 08dae01..01799a9 100644
>> --- a/include/linux/mfd/max77693-private.h
>> +++ b/include/linux/mfd/max77693-private.h
>> @@ -113,8 +113,8 @@ enum max77693_pmic_reg {
>>   #define FLASH_EN_FLASH		0x1
>>   #define FLASH_EN_TORCH		0x2
>>   #define FLASH_EN_ON		0x3
>> -#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
>> -#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
>> +#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
>> +#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
>>
>>   /* MAX77693 MAX_FLASH1 register */
>>   #define MAX_FLASH1_MAX_FL_EN	0x80
>


-- 
Best Regards,
Jacek Anaszewski
