Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaCLH7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:59:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4594 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaCLH7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:59:07 -0400
Message-ID: <532013C4.1000107@atmel.com>
Date: Wed, 12 Mar 2014 08:59:00 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, "Arnd Bergmann" <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: Re: [PATCH for 3.14] ARM: at91: fix network interface ordering for
 sama5d36
References: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com> <366E83ED-36B1-469F-891C-5B0E8916D85A@jcrosoft.com>
In-Reply-To: <366E83ED-36B1-469F-891C-5B0E8916D85A@jcrosoft.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 21:56, Jean-Christophe PLAGNIOL-VILLARD :
> 
> On Mar 10, 2014, at 10:37 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> From: Boris BREZILLON <b.brezillon.dev@gmail.com>
>>
>> On the newly introduced sama5d36, Gigabit and 10/100 Ethernet network
>> interfaces are probed in a different order than for the sama5d35.
>> Moreover, users are accustomed to this order in bootloaders and backports
>> for older kernel revisions.
>> So this patch switches DT node order as it is done for the other dual-Ethernet
>> sama5d3 SoC.
>> Better interface numbering which does not depend on DT node order is being
>> developed for stronger interface identification.
> 
> twick ethernet enumerating by playing on the DT order is week

Absolutely, that is what I said in the commit message.

> It’s better to introduce a new property
> 
> linux,ethernet-id or something like or simply rely on other information on the userspace to identify the
> proper interface

We will rely on the alias number ; It's its purpose, after all. I think
that Boris already have a preliminary patch for the macb driver.

Bye,

> Nicolas for AT91 keep me in Cc
> 
> Best Regards,
> J.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Olof, Arnd and Kevin,
>>
>> I would like to include this fix in 3.14-final.
>> I do not have anymore patch for an at91-3.14-fixes branch so I only send this
>> single patch to you. Can you still take it?
>>
>> Thanks, best regards,
>>
>> arch/arm/boot/dts/sama5d36.dtsi | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sama5d36.dtsi b/arch/arm/boot/dts/sama5d36.dtsi
>> index 6c31c26e6cc0..db58cad6acd3 100644
>> --- a/arch/arm/boot/dts/sama5d36.dtsi
>> +++ b/arch/arm/boot/dts/sama5d36.dtsi
>> @@ -8,8 +8,8 @@
>>  */
>> #include "sama5d3.dtsi"
>> #include "sama5d3_can.dtsi"
>> -#include "sama5d3_emac.dtsi"
>> #include "sama5d3_gmac.dtsi"
>> +#include "sama5d3_emac.dtsi"
>> #include "sama5d3_lcd.dtsi"
>> #include "sama5d3_mci2.dtsi"
>> #include "sama5d3_tcb1.dtsi"
>> -- 
>> 1.8.2.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 


-- 
Nicolas Ferre
