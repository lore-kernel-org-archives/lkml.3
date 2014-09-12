Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaILLCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:02:11 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:60412 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754067AbaILLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:02:08 -0400
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: kever.yang@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <8fe71e2cb4dcf4f2f49ab532b3b40a46>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5412D29B.8000600@rock-chips.com>
Date: Fri, 12 Sep 2014 19:01:47 +0800
From: mark <yzq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Mark yao <mark.yao@rock-chips.com>
CC: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, djkurtz@chromium.org,
        dianders@chromium.org, dkl@rock-chips.com, eddie.cai@rock-chips.com,
        xjq@rock-chips.com, kfx@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yxj@rock-chips.com, cym@rock-chips.com,
        zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: add VOP1 softresets and rename
 VOP0 softresets
References: <1410518004-19040-1-git-send-email-mark.yao@rock-chips.com> <3298686.YKlhYtF9M9@diego>
In-Reply-To: <3298686.YKlhYtF9M9@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年09月12日 18:41, Heiko Stübner wrote:
> Hi Mark,
>
> Am Freitag, 12. September 2014, 18:33:23 schrieb Mark yao:
>> The rk3288 have two vop, and each vop has three softresets were axi_reset,
>> ahb_reset and dclk_reset.
> I'm not sure about renaming the indices, since they're part of the devicetree-
> binding. We know that so far no device in the wild used them, so it might be
> ok.
now vop driver need these reset, so we need add it.
> But in any case could you also add the rest of the indices of the "new" reset
> registers please, so that we don't end up adding each small index in a
> separate patch.
>
> patch1: add reset indices for SOFTRST9 - SOFTRST11
> patch2: rename LCDC0 -> VOP0
OK, I will do it
>
> Heiko
>
>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
>> ---
>>   include/dt-bindings/clock/rk3288-cru.h | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/dt-bindings/clock/rk3288-cru.h
>> b/include/dt-bindings/clock/rk3288-cru.h index ebcb460..4d65959 100644
>> --- a/include/dt-bindings/clock/rk3288-cru.h
>> +++ b/include/dt-bindings/clock/rk3288-cru.h
>> @@ -235,9 +235,9 @@
>>   #define SRST_RGA_NIU		97
>>   #define SRST_VIO0_NIU_AXI	98
>>   #define SRST_VIO_NIU_AHB	99
>> -#define SRST_LCDC0_AXI		100
>> -#define SRST_LCDC0_AHB		101
>> -#define SRST_LCDC0_DCLK		102
>> +#define SRST_VOP0_AXI		100
>> +#define SRST_VOP0_AHB		101
>> +#define SRST_VOP0_DCLK		102
>>   #define SRST_VIO1_NIU_AXI	103
>>   #define SRST_VIP		104
>>   #define SRST_RGA_CORE		105
>> @@ -276,3 +276,7 @@
>>   #define SRST_USBHOST1_CON	140
>>   #define SRST_USB_ADP		141
>>   #define SRST_ACC_EFUSE		142
>> +
>> +#define SRST_VOP1_AXI		176
>> +#define SRST_VOP1_AHB		177
>> +#define SRST_VOP1_DCLK		178
>
>
>

