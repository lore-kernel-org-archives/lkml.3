Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaFZJj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:39:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbaFZJj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:39:27 -0400
Message-ID: <53ABEA49.5010808@ti.com>
Date: Thu, 26 Jun 2014 12:39:21 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>,
        <paul@pwsan.com>
CC: <rnayak@ti.com>, <nm@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: DRA7: hwmod: Add OCP2SCP3 module
References: <1403093816-10960-1-git-send-email-rogerq@ti.com> <1403093816-10960-2-git-send-email-rogerq@ti.com> <53AB0ADC.20004@ti.com>
In-Reply-To: <53AB0ADC.20004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kishon,

On 06/25/2014 08:46 PM, Kishon Vijay Abraham I wrote:
> 
> On Wednesday 18 June 2014 05:46 PM, Roger Quadros wrote:
>> This module is needed for the SATA and PCIe PHYs.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Tested-by: Roger Quadros <rogerq@ti.com>
> 
> I used this patch for testing PCIe.
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>

There is a v2 of this patch in reply to the original patch. Could you please give your Tested-by tag on that one?
Thanks.

cheers,
-roger

>> ---
>>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> index 20b4398..cedef6b 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> @@ -1215,6 +1215,30 @@ static struct omap_hwmod dra7xx_ocp2scp1_hwmod = {
>>  	},
>>  };
>>  
>> +/* ocp2scp3 */
>> +static struct omap_hwmod dra7xx_ocp2scp3_hwmod;
>> +
>> +/* l4_cfg -> ocp2scp3 */
>> +static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp3 = {
>> +	.master		= &dra7xx_l4_cfg_hwmod,
>> +	.slave		= &dra7xx_ocp2scp3_hwmod,
>> +	.clk		= "l4_root_clk_div",
>> +	.user		= OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
>> +	.name		= "ocp2scp3",
>> +	.class		= &dra7xx_ocp2scp_hwmod_class,
>> +	.clkdm_name	= "l3init_clkdm",
>> +	.prcm = {
>> +		.omap4 = {
>> +			.clkctrl_offs = DRA7XX_CM_L3INIT_OCP2SCP3_CLKCTRL_OFFSET,
>> +			.context_offs = DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET,
>> +			.modulemode   = MODULEMODE_HWCTRL,
>> +		},
>> +	},
>> +};
>> +
>>  /*
>>   * 'qspi' class
>>   *
>> @@ -2672,6 +2696,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>  	&dra7xx_l4_per1__mmc4,
>>  	&dra7xx_l4_cfg__mpu,
>>  	&dra7xx_l4_cfg__ocp2scp1,
>> +	&dra7xx_l4_cfg__ocp2scp3,
>>  	&dra7xx_l3_main_1__qspi,
>>  	&dra7xx_l4_cfg__sata,
>>  	&dra7xx_l4_cfg__smartreflex_core,
>>

