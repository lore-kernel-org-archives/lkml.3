Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaFZJgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:36:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40743 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaFZJgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:36:51 -0400
Message-ID: <53ABE9AD.1000100@ti.com>
Date: Thu, 26 Jun 2014 12:36:45 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>
CC: <rnayak@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
References: <1403700996-27105-1-git-send-email-rogerq@ti.com> <53AB4CE0.6020705@ti.com> <20140626073115.GD28884@atomide.com>
In-Reply-To: <20140626073115.GD28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 10:31 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [140625 15:29]:
>> On 06/25/2014 07:56 AM, Roger Quadros wrote:
>>> The SATA and USB PHYs need the 1.8V and 3.3V supplies.
>>> The PHY drivers/framework don't yet support regulator
>>> supply so we have to keep these regulators always-on till
>>> then.
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>  arch/arm/boot/dts/dra7-evm.dts | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>>> index 4adc280..99a1f79 100644
>>> --- a/arch/arm/boot/dts/dra7-evm.dts
>>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>>> @@ -241,6 +241,7 @@
>>>  					regulator-min-microvolt = <1800000>;
>>>  					regulator-max-microvolt = <1800000>;
>>>  					regulator-boot-on;
>>> +					regulator-always-on;
>>>  				};
>>>  
>>>  				ldo9_reg: ldo9 {
>>> @@ -266,6 +267,7 @@
>>>  					regulator-min-microvolt = <3300000>;
>>>  					regulator-max-microvolt = <3300000>;
>>>  					regulator-boot-on;
>>> +					regulator-always-on;
>>>  				};
>>>  			};
>>>  		};
>>>
>>
>> Why not fix phy driver/framework as needed? the trouble is people
>> always forget to remove always-on... who actually audits old logs and
>> fixes stuff back up?
> 
> Yes I agree let's not play with the regulator-always-on unless
> absolutely necessary.
> 
Agreed. PHY framework must deal with this. Till then USB, SATA and most likely PCIe as well will not work on DRA7-evm.

cheers,
-roger

