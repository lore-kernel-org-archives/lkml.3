Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3FJDnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:43:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62766 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FJDnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:43:18 -0400
Message-ID: <51B54B4F.3000503@linaro.org>
Date: Mon, 10 Jun 2013 09:13:11 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org,
        swarren@wwwdotorg.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        broonie@kernel.org, l.majewski@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH 2/2] clk: exynos4: Add alias for cpufreq related clocks
References: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org> <1370517749-29892-3-git-send-email-tushar.behera@linaro.org> <2070978.AjQD2isvSl@flatron>
In-Reply-To: <2070978.AjQD2isvSl@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 05:20 PM, Tomasz Figa wrote:
> On Thursday 06 of June 2013 16:52:28 Tushar Behera wrote:
>> cpufreq driver for EXYNOS4 based SoCs are not platform drivers, hence
>> we cannot currently pass the clock names through a device tree node.
>> Instead, we need to make them available through a global alias.
>>
>> 'armclk', 'moutcore', 'mout_mpll' and 'mout_apll' clock aliases are
>> defined.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  drivers/clk/samsung/clk-exynos4.c |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos4.c
>> b/drivers/clk/samsung/clk-exynos4.c index 3c1f888..1e4258a 100644
>> --- a/drivers/clk/samsung/clk-exynos4.c
>> +++ b/drivers/clk/samsung/clk-exynos4.c
>> @@ -356,8 +356,8 @@ struct samsung_fixed_rate_clock
>> exynos4210_fixed_rate_clks[] __initdata = {
>>
>>  /* list of mux clocks supported in all exynos4 soc's */
>>  struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
>> -	MUX_F(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
>> -			CLK_SET_RATE_PARENT, 0),
>> +	MUX_FA(mout_apll, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
>> +			CLK_SET_RATE_PARENT, 0, "mout_apll"),
>>  	MUX(none, "mout_hdmi", mout_hdmi_p, SRC_TV, 0, 1),
>>  	MUX(none, "mout_mfc1", sclk_evpll_p, SRC_MFC, 4, 1),
>>  	MUX(none, "mout_mfc", mout_mfc_p, SRC_MFC, 8, 1),
>> @@ -385,9 +385,9 @@ struct samsung_mux_clock exynos4210_mux_clks[]
>> __initdata = { MUX(none, "mout_g2d", mout_g2d_p, E4210_SRC_IMAGE, 8,
>> 1),
>>  	MUX(none, "mout_fimd1", group1_p4210, E4210_SRC_LCD1, 0, 4),
>>  	MUX(none, "mout_mipi1", group1_p4210, E4210_SRC_LCD1, 12, 4),
>> -	MUX_A(sclk_mpll, "sclk_mpll", mout_mpll_p, SRC_CPU, 8, 1, 
> "sclk_mpll"),
>> +	MUX_A(sclk_mpll, "sclk_mpll", mout_mpll_p, SRC_CPU, 8, 1, 
> "mout_mpll"),
> 
> This is not fully compliant with patch description. I'm not sure if there 
> weren't any users of the sclk_mpll alias.
> 

As of now, there are no other users of sclk_mpll other than a debug
print within the same file.

>>  	MUX_A(mout_core, "mout_core", mout_core_p4210,
>> -			SRC_CPU, 16, 1, "mout_core"),
>> +			SRC_CPU, 16, 1, "moutcore"),
> 
> IMHO those typo corrections are not part of this patch.
> 

But the older drivers (before migration to CCF) were using the clock
"moutcore" (not "mout_core").

>>  	MUX_A(sclk_vpll, "sclk_vpll", sclk_vpll_p4210,
>>  			SRC_TOP0, 8, 1, "sclk_vpll"),
>>  	MUX(mout_fimc0, "mout_fimc0", group1_p4210, SRC_CAM, 0, 4),
>> @@ -534,7 +534,7 @@ struct samsung_div_clock exynos4_div_clks[]
>> __initdata = { DIV(none, "div_spi_pre2", "div_spi2", DIV_PERIL2, 8, 8),
>>  	DIV(none, "div_audio1", "mout_audio1", DIV_PERIL4, 0, 4),
>>  	DIV(none, "div_audio2", "mout_audio2", DIV_PERIL4, 16, 4),
>> -	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, 
> "arm_clk"),
>> +	DIV_A(arm_clk, "arm_clk", "div_core2", DIV_CPU0, 28, 3, "armclk"),
> 
> Same here.
> 

Same as above, "armclk" is used elsewhere, not "arm_clk".

>>  	DIV_A(sclk_apll, "sclk_apll", "mout_apll",
>>  			DIV_CPU0, 24, 3, "sclk_apll"),
>>  	DIV_F(none, "div_mipi_pre0", "div_mipi0", DIV_LCD0, 20, 4,
> 
> Basically I don't like the idea of those global aliases, which IMHO should 
> be completely dropped. Someone might not like it, but I'd go with the 
> conversion of our cpufreq drivers to platform drivers instead, which could 
> receive things like clocks and regulators using DT-based lookups.
> 

I agree. Migration of exynos-cpufreq driver as a platform driver is the
best solution. But unless someone picks up that work, cpufreq support
for EXYNOS4 based systems is broken because of the incorrect clock aliases.

> This is especially important in case of regulators, which currently have 
> to be hacked by using vdd_arm as regulator name in device tree.
> 

Agree.

> CCing people that might be interested in this topic.
> 
> Best regards,
> Tomasz
> 

Thanks.

-- 
Tushar Behera
