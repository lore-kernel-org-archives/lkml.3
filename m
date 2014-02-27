Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaB0M2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:28:01 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:49692 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbaB0M15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:27:57 -0500
Message-ID: <530F2F25.7000801@st.com>
Date: Thu, 27 Feb 2014 13:27:17 +0100
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Cc: <alexandre.torgue@st.com>, Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-2-git-send-email-patrice.chotard@st.com> <530F2E26.1040304@st.com>
In-Reply-To: <530F2E26.1040304@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime

Thanks for reviewing.
Yes for sure, i will add additional board informations.

Patrice

On 02/27/2014 01:23 PM, Maxime Coquelin wrote:
> Hi Patrice,
>
> Could you add an overview documentation as it has been done for other 
> STi platforms?
>
> See Documentation/arm/sti/stih416-overview.txt
>
> Thanks,
> Maxime
>
> On 01/30/2014 03:55 PM, Patrice CHOTARD wrote:
>> From: Alexandre TORGUE <alexandre.torgue@st.com>
>>
>> This patch adds support to STiD127 SoC.
>> The main adaptation is the L2 cache way size compare to STiH41x SoCs.
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
>> ---
>>   arch/arm/mach-sti/board-dt.c |    6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
>> index 1217fb5..be018a9 100644
>> --- a/arch/arm/mach-sti/board-dt.c
>> +++ b/arch/arm/mach-sti/board-dt.c
>> @@ -9,6 +9,7 @@
>>
>>   #include <linux/irq.h>
>>   #include <linux/of_platform.h>
>> +#include <linux/of.h>
>>   #include <asm/hardware/cache-l2x0.h>
>>   #include <asm/mach/arch.h>
>>
>> @@ -18,6 +19,10 @@ void __init stih41x_l2x0_init(void)
>>   {
>>       u32 way_size = 0x4;
>>       u32 aux_ctrl;
>> +
>> +    if (of_machine_is_compatible("st,stid127"))
>> +        way_size = 0x3;
>> +
>>       /* may be this can be encoded in macros like BIT*() */
>>       aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
>>           (0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
>> @@ -36,6 +41,7 @@ static void __init stih41x_machine_init(void)
>>   static const char *stih41x_dt_match[] __initdata = {
>>       "st,stih415",
>>       "st,stih416",
>> +    "st,stid127",
>>       NULL
>>   };
>>
>>

