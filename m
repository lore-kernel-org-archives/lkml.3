Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaGYPZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:25:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49131 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaGYPZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:25:02 -0400
Message-ID: <53D276A0.3070800@ti.com>
Date: Fri, 25 Jul 2014 20:54:16 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>, <paul@pwsan.com>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <j-keerthy@ti.com>,
        <rogerq@ti.com>
Subject: Re: [PATCH 2/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific
 ocp interface lists
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com> <1405499774-19770-3-git-send-email-lokeshvutla@ti.com> <53CE9652.4080304@ti.com>
In-Reply-To: <53CE9652.4080304@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,
On Tuesday 22 July 2014 10:20 PM, Nishanth Menon wrote:
> On 07/16/2014 03:36 AM, Lokesh Vutla wrote:
>> From: Rajendra Nayak <rnayak@ti.com>
>>
>> To deal with IPs which are specific to dra74x and dra72x, maintain seperate
>> ocp interface lists, while keeping the common list for all common IPs.
>>
>> Move USB OTG SS4 to dra74x only list since its unavailable in
>> dra72x and is giving an abort during boot. The dra72x only list
>> is empty for now and a placeholder for future hwmod additions which
>> are specific to dra72x.
>>
>> Fixes: d904b38 ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
> 
> please use a format as following:
> Fixes: d904b38df0db13 ("ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss")
> 
>> Reported-by: Keerthy <j-keerthy@ti.com>
>> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
>>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
>>  2 files changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
>> index 6c074f3..14f8370 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod.c
>> @@ -3345,6 +3345,9 @@ int __init omap_hwmod_register_links(struct omap_hwmod_ocp_if **ois)
>>  	if (!ois)
>>  		return 0;
>>  
>> +	if (ois[0] == NULL) /*empty list*/
> /* Empty list */ ?
>> +		return 0;
>> +
> 
> This change looks like a different patch?
> 
>>  	if (!linkspace) {
>>  		if (_alloc_linkspace(ois)) {
>>  			pr_err("omap_hwmod: could not allocate link space\n");
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> index 284324f..c95033c 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
>> @@ -35,6 +35,7 @@
>>  #include "i2c.h"
>>  #include "mmc.h"
>>  #include "wd_timer.h"
>> +#include "soc.h"
>>  
>>  /* Base offset for all DRA7XX interrupts external to MPUSS */
>>  #define DRA7XX_IRQ_GIC_START	32
>> @@ -2705,7 +2706,6 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>  	&dra7xx_l4_per3__usb_otg_ss1,
>>  	&dra7xx_l4_per3__usb_otg_ss2,
>>  	&dra7xx_l4_per3__usb_otg_ss3,
>> -	&dra7xx_l4_per3__usb_otg_ss4,
>>  	&dra7xx_l3_main_1__vcp1,
>>  	&dra7xx_l4_per2__vcp1,
>>  	&dra7xx_l3_main_1__vcp2,
>> @@ -2714,8 +2714,26 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
>>  	NULL,
>>  };
>>  
>> +static struct omap_hwmod_ocp_if *dra74x_hwmod_ocp_ifs[] __initdata = {
>> +	&dra7xx_l4_per3__usb_otg_ss4,
>> +	NULL,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *dra72x_hwmod_ocp_ifs[] __initdata = {
>> +	NULL,
>> +};
>> +
>>  int __init dra7xx_hwmod_init(void)
>>  {
>> +	int ret;
>> +
>>  	omap_hwmod_init();
>> -	return omap_hwmod_register_links(dra7xx_hwmod_ocp_ifs);
>> +	ret = omap_hwmod_register_links(dra7xx_hwmod_ocp_ifs);
> if (ret)
> 	goto out;
>> +
>> +	if (!ret && soc_is_dra74x())
> no need of !ret
>> +		return omap_hwmod_register_links(dra74x_hwmod_ocp_ifs);
> ret = omap_hwmod_register_links(dra74x_hwmod_ocp_ifs);
>> +	else if (!ret && soc_is_dra72x())
> no need of else and !ret
>> +		return omap_hwmod_register_links(dra72x_hwmod_ocp_ifs);
> ret = omap_hwmod_register_links(dra72x_hwmod_ocp_ifs);
>> +
> 
> out:
>> +	return ret;
After looking closely into it, I realized that currently its the same logic of what you are
suggesting.  If there is no error from registering common lists then only go for registering the
Soc specific lists.
Do you still want me to go ahead and make this change?

Thanks and regards,
Lokesh
>>  }
>>
> 
> 

