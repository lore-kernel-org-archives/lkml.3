Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3KOQDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:03:21 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42961 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KOQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:03:16 -0500
Message-ID: <528645C1.3060601@linux.com>
Date: Fri, 15 Nov 2013 17:03:13 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?windows-1252?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
CC: Caizhiyong <caizhiyong@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <levex@linux.com>
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
References: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>	<CAGG-pUT22xoksid-2GmJsDmVQk8gR8zHvAr=r3Z2E4BLf+1jJA@mail.gmail.com>	<5286215A.4020009@linux.com> <CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
In-Reply-To: <CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-15 16:52 keltezéssel, Geyslan Gregório Bem írta:
> 2013/11/15 Levente Kurusa <levex@linux.com>:
>> 2013-11-15 14:00 keltezéssel, Geyslan Gregório Bem írta:
>>> 2013/11/15 Caizhiyong <caizhiyong@hisilicon.com>:
>>>> From: Cai Zhiyong <caizhiyong@huawei.com>
>>>> Date: Mon, 11 Nov 2013 19:26:14 +0800
>>>> Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
>>>>
>>>> This patch give a warning when calling regmap_register_patch with
>>>> parameter num_regs <= 0.
>>>>
>>>> When the num_regs parameter is zero and krealloc doesn't fail,
>>>> then the code would return an uninitialized value. However,
>>>> calling this function with num_regs == 0, would be a waste as it
>>>> essentially does nothing.
>>>>
>>>> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
>>> Reviewed-by: Geyslan G. Bem <geyslan@gmail.com>
>>>
>>> Seems a good approach.
>>>
>>
>> The patch doesn't apply. After manually applying this it
>> threw a compilation error:
>>
>> drivers/base/regmap/regmap.c: In function ‘regmap_register_patch’:
>> drivers/base/regmap/regmap.c:2176:6: error: expected expression before ‘)’ token
>>
>>
>> Cai,
>> You have missed the second parameter of WARN_ONCE().
>> Please append what you'd prefer to have outputten once the condition evaluates to true.
>>
>> --
>> Regards,
>> Levente Kurusa
> Cai, Levente,
> 
> Maybe this:
> 
> +       if (WARN_ONCE(num_regs <= 0, "number of registers [%d] must be
> major than 0", num_regs))
> +               return 0;
> +
> 

It is fine, but I think outputting num_regs is unnecessary.
Also, that line is more than 80 characters, so please wrap it.

-- 
Regards,
Levente Kurusa
