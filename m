Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaISOdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:33:07 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:46860 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaISOdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:33:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Sep 2014 16:32:33 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: kernel@pengutronix.de, festevam@gmail.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: vf610: Add ARM Global Timer
In-Reply-To: <20140912075900.GK18566@dragon>
References: <1410437175-6636-1-git-send-email-stefan@agner.ch>
 <20140912075900.GK18566@dragon>
Message-ID: <42e11ee7107cacb92fa3a477e61dc6d4@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-12 09:59, schrieb Shawn Guo:
> On Thu, Sep 11, 2014 at 02:06:14PM +0200, Stefan Agner wrote:
>> Add Global Timer support which is part of the Snoop Control Unit
>> of the Cortex-A5 processor. This Global Timer is compatible with the
>> Cortex-A9 implementation. It's a 64-bit timer and is clocked by the
>> peripheral clock, which is typically 133 or 166MHz on Vybrid.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/boot/dts/vf610.dtsi | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
>> index 4d2ec32..a03abf6 100644
>> --- a/arch/arm/boot/dts/vf610.dtsi
>> +++ b/arch/arm/boot/dts/vf610.dtsi
>> @@ -11,6 +11,7 @@
>>  #include "vf610-pinfunc.h"
>>  #include <dt-bindings/clock/vf610-clock.h>
>>  #include <dt-bindings/interrupt-controller/irq.h>
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>>
>>  / {
>>  	aliases {
>> @@ -83,6 +84,13 @@
>>  				      <0x40002100 0x100>;
>>  			};
>>
>> +			global_timer: global-timer@40002200 {
> 
> I think it's more idiomatic to use the generic name 'timer' for the
> node.

Agree to that. I guess you can change that when you apply it, in case
there are no other objections to this patchset..?

> 
> Shawn
> 
>> +				compatible = "arm,cortex-a9-global-timer";
>> +				reg = <0x40002200 0x20>;
>> +				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
>> +			};
>> +
>>  			L2: l2-cache@40006000 {
>>  				compatible = "arm,pl310-cache";
>>  				reg = <0x40006000 0x1000>;
>> --
>> 2.1.0
>>


--
Stefan
