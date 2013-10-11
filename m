Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3JKGOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:14:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39032 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3JKGOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:14:46 -0400
Message-ID: <52579723.6080209@ti.com>
Date: Fri, 11 Oct 2013 11:43:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <bcousson@baylibre.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <tony@atomide.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <20131010141949.GA13277@kahuna>
In-Reply-To: <20131010141949.GA13277@kahuna>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 October 2013 07:49 PM, Nishanth Menon wrote:
> On 16:19-20131010, Kishon Vijay Abraham I wrote:
>> smps10 should be enabled only in the case of host mode. So stop
>> doing always_on, boot_on from smps10_out1. The driver will enable it in host
>> mode.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  arch/arm/boot/dts/omap5-uevm.dts |    2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
>> index d784b3a..e06a04a 100644
>> --- a/arch/arm/boot/dts/omap5-uevm.dts
>> +++ b/arch/arm/boot/dts/omap5-uevm.dts
>> @@ -334,8 +334,6 @@
>>  					regulator-name = "smps10_out1";
>>  					regulator-min-microvolt = <5000000>;
>>  					regulator-max-microvolt = <5000000>;
>> -					regulator-always-on;
>> -					regulator-boot-on;
>>  				};
>>  
>>  				ldo1_reg: ldo1 {
>> -- 
> Always good to get rid of regulator-always-on. Thanks for it.
> 
> regulator-boot-on indicates that PMIC enables it by default as part of
> OTP or some internal behavior -> Looking at the measurements done on
> uEVM and OTP information -> regulator-boot-on should be kept here.

No. Actually I don’t want PMIC to enable it by default. I want the palmas-usb
driver to handle it.
Enabling it by default makes palmas-usb to detect VBUS interrupt. This should
ideally be detected only when you connect a host cable.
Btw I didn't exactly get why you want regulator-boot-on should be kept here.

Thanks
Kishon
