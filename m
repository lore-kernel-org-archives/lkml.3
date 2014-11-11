Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKKVFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:05:32 -0500
Received: from mail2.kmu-office.ch ([178.209.48.109]:49134 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaKKVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:05:26 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 16:05:26 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2014 21:58:54 +0100
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 1/3] ARM: imx: clk-vf610: Add clock for SNVS
In-Reply-To: <20141111144911.GH2704@dragon>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
 <20141111144911.GH2704@dragon>
Message-ID: <a20b88f31022d9318d1193fa46aafd3c@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Nov 11 21:57:43 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 5462784712813467639389
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-11 15:49, Shawn Guo wrote:
> On Fri, Nov 07, 2014 at 06:34:26PM +0530, Sanchayan Maity wrote:
>> This patch adds support for clock gating of
>> the SNVS peripheral.
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>> ---
>>  arch/arm/mach-imx/clk-vf610.c           |    1 +
>>  include/dt-bindings/clock/vf610-clock.h |    3 ++-
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
>> index 5937dde..bbf4785 100644
>> --- a/arch/arm/mach-imx/clk-vf610.c
>> +++ b/arch/arm/mach-imx/clk-vf610.c
>> @@ -379,6 +379,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
>>  	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
>>  	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
>>  	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
>> +	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs-rtc", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(7));
> 
> Stefan,
> 
> Would you confirm this register bits is the gating for SNVS clock?  I
> cannot find it in my Vybrid Reference Manual.

The RTC is part of the secure stuff. The clock gate bits are correct.

 
>>
>>  	imx_check_clocks(clk, ARRAY_SIZE(clk));
>>
>> diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
>> index 801c0ac..979d24a 100644
>> --- a/include/dt-bindings/clock/vf610-clock.h
>> +++ b/include/dt-bindings/clock/vf610-clock.h
>> @@ -192,6 +192,7 @@
>>  #define VF610_PLL5_BYPASS		179
>>  #define VF610_PLL6_BYPASS		180
>>  #define VF610_PLL7_BYPASS		181
>> -#define VF610_CLK_END			182
>> +#define VF610_CLK_SNVS			182
>> +#define VF610_CLK_END			183
>>
>>  #endif /* __DT_BINDINGS_CLOCK_VF610_H */
>> --
>> 1.7.9.5
>>

