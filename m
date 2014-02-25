Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaBYJcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:32:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51836 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:32:48 -0500
Message-ID: <530C6323.90205@ti.com>
Date: Tue, 25 Feb 2014 11:32:19 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v8 06/14] CLK: TI: OMAP3: Get rid of unused USB Host dummy
 clocks
References: <1392896409-5101-1-git-send-email-rogerq@ti.com> <1392896409-5101-7-git-send-email-rogerq@ti.com> <20140225084327.22529.86075@quantum>
In-Reply-To: <20140225084327.22529.86075@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 02/25/2014 10:43 AM, Mike Turquette wrote:
> Quoting Roger Quadros (2014-02-20 03:40:01)
>> The OMAP USB Host MFD driver no longer expects these non-existing
>> clocks from the OMAP3 platform, so get rid of them.
> 
> Looks good to me.

Is it OK if I squash this patch with [1] and take it through the MFD tree?
Keeping them separate could break functionality if both don't go in together.

[1] - http://article.gmane.org/gmane.linux.ports.arm.kernel/303266

cheers,
-roger

> 
>>
>> CC: Tero Kristo <t-kristo@ti.com>
>> CC: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  arch/arm/mach-omap2/cclock3xxx_data.c | 4 ----
>>  drivers/clk/ti/clk-3xxx.c             | 4 ----
>>  2 files changed, 8 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
>> index 3b05aea..4299a55 100644
>> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
>> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
>> @@ -3495,10 +3495,6 @@ static struct omap_clk omap3xxx_clks[] = {
>>         CLK(NULL,       "dss_tv_fck",   &dss_tv_fck),
>>         CLK(NULL,       "dss_96m_fck",  &dss_96m_fck),
>>         CLK(NULL,       "dss2_alwon_fck",       &dss2_alwon_fck),
>> -       CLK(NULL,       "utmi_p1_gfclk",        &dummy_ck),
>> -       CLK(NULL,       "utmi_p2_gfclk",        &dummy_ck),
>> -       CLK(NULL,       "xclk60mhsp1_ck",       &dummy_ck),
>> -       CLK(NULL,       "xclk60mhsp2_ck",       &dummy_ck),
>>         CLK(NULL,       "init_60m_fclk",        &dummy_ck),
>>         CLK(NULL,       "gpt1_fck",     &gpt1_fck),
>>         CLK(NULL,       "aes2_ick",     &aes2_ick),
>> diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
>> index d323023..0d1750a 100644
>> --- a/drivers/clk/ti/clk-3xxx.c
>> +++ b/drivers/clk/ti/clk-3xxx.c
>> @@ -130,10 +130,6 @@ static struct ti_dt_clk omap3xxx_clks[] = {
>>         DT_CLK(NULL, "dss_tv_fck", "dss_tv_fck"),
>>         DT_CLK(NULL, "dss_96m_fck", "dss_96m_fck"),
>>         DT_CLK(NULL, "dss2_alwon_fck", "dss2_alwon_fck"),
>> -       DT_CLK(NULL, "utmi_p1_gfclk", "dummy_ck"),
>> -       DT_CLK(NULL, "utmi_p2_gfclk", "dummy_ck"),
>> -       DT_CLK(NULL, "xclk60mhsp1_ck", "dummy_ck"),
>> -       DT_CLK(NULL, "xclk60mhsp2_ck", "dummy_ck"),
>>         DT_CLK(NULL, "init_60m_fclk", "dummy_ck"),
>>         DT_CLK(NULL, "gpt1_fck", "gpt1_fck"),
>>         DT_CLK(NULL, "aes2_ick", "aes2_ick"),
>> -- 
>> 1.8.3.2
>>

