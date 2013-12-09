Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab3LIIuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:50:35 -0500
Received: from 18.mo6.mail-out.ovh.net ([46.105.73.110]:53284 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754336Ab3LIIud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:50:33 -0500
Message-ID: <52A582AB.6010504@overkiz.com>
Date: Mon, 09 Dec 2013 09:43:23 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <1385650228-8906-1-git-send-email-b.brezillon@overkiz.com> <201312090309.23723.arnd@arndb.de>
In-Reply-To: <201312090309.23723.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9441515145830365188
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 09/12/2013 03:09, Arnd Bergmann wrote:
> On Thursday 28 November 2013, Boris BREZILLON wrote:
>> @@ -92,6 +103,8 @@
>>   				dma-names = "tx", "rx";
>>   				pinctrl-names = "default";
>>   				pinctrl-0 = <&pinctrl_spi0>;
>> +				clocks = <&spi0_clk>;
>> +				clock-names = "spi_clk";
>>   				status = "disabled";
>>   			};
>>   
>> @@ -101,6 +114,8 @@
>>   				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
>>   				pinctrl-names = "default";
>>   				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
>> +				clocks = <&ssc0_clk>;
>> +				clock-names = "pclk";
>>   				status = "disabled";
>>   			};
>>   
> You are adding "clock-names" properties in a lot of cases. Are you sure you
> are using the strings that are documented in the respective device bindings
> for each name? In a lot of cases, drivers just want an anonymous clock
> and we don't name them.

I rechecked it, and almost all drivers call [devm_]clk_get with a 
specific clock
name, and as a result we must specify the "clock-names" property.
The only exceptions I found are the spi and PIT (Periodic Interval 
Timer) drivers,
and "clock-names" property is not defined in these nodes.


Best Regards,

Boris
>
> 	Arnd

