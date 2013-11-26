Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3KZLQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:16:38 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17458 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3KZLQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:16:36 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f5-b7f706d0000017c2-b8-5294831245a8
Content-transfer-encoding: 8BIT
Message-id: <52948310.9080409@samsung.com>
Date: Tue, 26 Nov 2013 12:16:32 +0100
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
Newsgroups: gmane.linux.kernel
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: s5m-rtc: Fix info->rtc assignment
References: <1384516479-31791-1-git-send-email-geert@linux-m68k.org>
 <5294673B.4050608@samsung.com>
In-reply-to: <5294673B.4050608@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7pCzVOCDI4/krWYs34Nm8WzW3uZ
	LF6/MLS4vGsOm8X+zg5Gi5N/ehktLq74wuTA7rFn4kk2jzvX9rB5nJjxm8Xj0OEORo++LasY
	PT5vkgtgi+KySUnNySxLLdK3S+DKaHj2k63gLWfFyot3mRsYOzi6GDk5JARMJG7ceMsOYYtJ
	XLi3nq2LkYtDSGApo8TP2e+ZQBK8AoISPybfY+li5OBgFpCXOHIpGyTMLGAm8ahlHTOILSTw
	mVHi3hZfiHItiZdbOsDiLAKqEkv+zmIBsdkEjCU2L1/CBmKLCkRI/J23nhHE5hOQk5i49Rkz
	yF4RgRWMEje6zrNBLLCRWPhjOivIXmEBa4lrz/MhdqVK/Hp6D6yXU0Bb4lLHbqYJjIKzkFw6
	C+HSWUguXcDIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJAK+7mBceszqEKMAB6MSD69E
	5+QgIdbEsuLK3EOMEhzMSiK898umBAnxpiRWVqUW5ccXleakFh9iZOLglGpgLP5vdMFsWZ2h
	j3ZDtgX/DK7q4PLVCrtM2R13n2XtsD60aIG0JHPYsdKpCpNfZXs8MOJ4kmv8T/nwH0/Lc/a+
	GaI/FGu3/EwQ2eNqJlNtfoOnNjGPzVGueXu+quYtB56f0w2WbmmUb4pw/h6hMm+KRs+a8rBm
	menutlFR/uEcc19qGCs1BSuxFGckGmoxFxUnAgBgH98TXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:17 AM, Krzysztof Kozlowski wrote:
> On 11/15/2013 12:54 PM, Geert Uytterhoeven wrote:
>> drivers/rtc/rtc-s5m.c: In function ‘s5m_rtc_probe’:
>> drivers/rtc/rtc-s5m.c:545: warning: assignment from incompatible
>> pointer type
>>
>> struct s5m_rtc_info.rtc has type "struct regmap *", while
>> struct sec_pmic_dev.rtc has type "struct i2c_client *".
>>
>> Probably the author wanted to assign "struct sec_pmic_dev.regmap", which
>> has the correct type.
>>
>> Also, as "rtc" doesn't make much sense as a name for a regmap, rename
>> it to
>> "regmap".
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> I would be really surprised if this driver didn't just crash...
>> Please test. Thanks!
>>
>>   drivers/rtc/rtc-s5m.c |   54
>> ++++++++++++++++++++++++-------------------------
>>   1 file changed, 27 insertions(+), 27 deletions(-)
>
> Seems good, tested on device with S5M8767.
>
> Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Arrrg, the fix is needed but not sufficient. The chip has different I2C 
addresses for RTC and PMIC so additional regmap is needed. Currently 
this rtc-s5m driver does not work. I'll send patches fixing it.

Best regards,
Krzysztof




