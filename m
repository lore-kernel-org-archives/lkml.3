Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3KOPwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:52:25 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36169 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3KOPwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:52:20 -0500
MIME-Version: 1.0
In-Reply-To: <5286215A.4020009@linux.com>
References: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
	<CAGG-pUT22xoksid-2GmJsDmVQk8gR8zHvAr=r3Z2E4BLf+1jJA@mail.gmail.com>
	<5286215A.4020009@linux.com>
Date: Fri, 15 Nov 2013 13:52:19 -0200
Message-ID: <CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: levex@linux.com
Cc: Caizhiyong <caizhiyong@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/15 Levente Kurusa <levex@linux.com>:
> 2013-11-15 14:00 keltezéssel, Geyslan Gregório Bem írta:
>> 2013/11/15 Caizhiyong <caizhiyong@hisilicon.com>:
>>> From: Cai Zhiyong <caizhiyong@huawei.com>
>>> Date: Mon, 11 Nov 2013 19:26:14 +0800
>>> Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
>>>
>>> This patch give a warning when calling regmap_register_patch with
>>> parameter num_regs <= 0.
>>>
>>> When the num_regs parameter is zero and krealloc doesn't fail,
>>> then the code would return an uninitialized value. However,
>>> calling this function with num_regs == 0, would be a waste as it
>>> essentially does nothing.
>>>
>>> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
>> Reviewed-by: Geyslan G. Bem <geyslan@gmail.com>
>>
>> Seems a good approach.
>>
>
> The patch doesn't apply. After manually applying this it
> threw a compilation error:
>
> drivers/base/regmap/regmap.c: In function ‘regmap_register_patch’:
> drivers/base/regmap/regmap.c:2176:6: error: expected expression before ‘)’ token
>
>
> Cai,
> You have missed the second parameter of WARN_ONCE().
> Please append what you'd prefer to have outputten once the condition evaluates to true.
>
> --
> Regards,
> Levente Kurusa
Cai, Levente,

Maybe this:

+       if (WARN_ONCE(num_regs <= 0, "number of registers [%d] must be
major than 0", num_regs))
+               return 0;
+

-- 
Regards,

Geyslan G. Bem
hackingbits.com
