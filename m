Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbaCDJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:22:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58084 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:22:17 -0500
Message-ID: <53159B21.6030102@ti.com>
Date: Tue, 4 Mar 2014 11:21:37 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 06/12] phy: omap: Select OMAP_OCP2SCP bus driver
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-7-git-send-email-rogerq@ti.com> <20140303185235.GC25804@atomide.com>
In-Reply-To: <20140303185235.GC25804@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 08:52 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140303 07:11]:
>> The OMAP_USB2 and OMAP_PIP3 phy devices will not be
>> detected if the OMAP_OCP2SCP driver is not present.
>> So select it.
> 
> Selecting drivers like this will easily lead into missing
> dependencies. Especially it's bad for tristate driver
> options that people may want to have as loadable modules.
> 
> How about instead depends on OMAP_OCP2SCP?

OK, 'depends' seems fine.

cheers,
-roger

> 
>  
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/phy/Kconfig | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 2f02ec8..afdab3e 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -44,6 +44,7 @@ config OMAP_USB2
>>  	depends on USB_PHY
>>  	select GENERIC_PHY
>>  	select OMAP_CONTROL_PHY
>> +	select OMAP_OCP2SCP
>>  	help
>>  	  Enable this to support the transceiver that is part of SOC. This
>>  	  driver takes care of all the PHY functionality apart from comparator.
>> @@ -55,6 +56,7 @@ config TI_PIPE3
>>  	depends on ARCH_OMAP2PLUS || COMPILE_TEST
>>  	select GENERIC_PHY
>>  	select OMAP_CONTROL_PHY
>> +	select OMAP_OCP2SCP
>>  	help
>>  	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
>>  	  driver takes care of all the PHY functionality apart from comparator.
>> -- 
>> 1.8.3.2
>>

