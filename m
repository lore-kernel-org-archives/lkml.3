Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbaJUQc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:32:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16576 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbaJUQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:32:26 -0400
Message-ID: <54468A93.6080707@atmel.com>
Date: Tue, 21 Oct 2014 18:32:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andreas Henriksson <andreas.henriksson@endian.se>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: sam9263: fix PLLB frequencies
References: <1412949021-15150-1-git-send-email-alexandre.belloni@free-electrons.com> <20141010160148.57290e20@bbrezillon>
In-Reply-To: <20141010160148.57290e20@bbrezillon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 16:01, Boris Brezillon :
> On Fri, 10 Oct 2014 15:50:21 +0200
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
>> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>>
>> PLLB input and output ranges were wrongly copied from at91sam9261 as the
>> datasheet didn't mention explicitly PLLB. Correct their values.
>>
>> This fixes USB.
>>
>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Thanks for sending this patch.
> 
> Just adding Andreas in Cc and adding his Reported and Tested-by.
> 
> Reported-by: Andreas Henriksson <andreas.henriksson@endian.se>
> Tested-by: Andreas Henriksson <andreas.henriksson@endian.se>

Added to the tag area of the patch and stacked on at91-3.18-fixes branch.

Thanks!

> 
>> ---
>>  arch/arm/boot/dts/at91sam9263.dtsi | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
>> index d68b3c4862bc..51416c7d0625 100644
>> --- a/arch/arm/boot/dts/at91sam9263.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
>> @@ -122,9 +122,10 @@
>>  					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
>>  					clocks = <&main>;
>>  					reg = <1>;
>> -					atmel,clk-input-range = <1000000 5000000>;
>> +					atmel,clk-input-range = <1000000 32000000>;
>>  					#atmel,pll-clk-output-range-cells = <4>;
>> -					atmel,pll-clk-output-ranges = <70000000 130000000 1 1>;
>> +					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
>> +								<190000000 240000000 2 1>;
>>  				};
>>  
>>  				mck: masterck {
> 
> 
> 


-- 
Nicolas Ferre
