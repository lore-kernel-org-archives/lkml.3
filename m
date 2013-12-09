Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab3LIQRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:17:15 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:52101 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816Ab3LIQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:17:12 -0500
Message-ID: <52A5ED03.2070306@overkiz.com>
Date: Mon, 09 Dec 2013 17:17:07 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <201312090309.23723.arnd@arndb.de> <52A582AB.6010504@overkiz.com> <201312091648.13802.arnd@arndb.de>
In-Reply-To: <201312091648.13802.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17104671384995461124
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 09/12/2013 16:48, Arnd Bergmann wrote:
> On Monday 09 December 2013, boris brezillon wrote:
>>> You are adding "clock-names" properties in a lot of cases. Are you sure you
>>> are using the strings that are documented in the respective device bindings
>>> for each name? In a lot of cases, drivers just want an anonymous clock
>>> and we don't name them.
>> I rechecked it, and almost all drivers call [devm_]clk_get with a
>> specific clock
>> name, and as a result we must specify the "clock-names" property.
>> The only exceptions I found are the spi and PIT (Periodic Interval
>> Timer) drivers,
>> and "clock-names" property is not defined in these nodes.
> Yes, I understood that the *drivers* use the names, but are they actually
> documented in the device bindings? If not, it might be better to change the
> drivers.

We have to keep both clk system working for at91 platform (new CCF based
clk implementations and old clk implementations) for two reasons:
1) the new clk implemetations are only compatible with DT enabled boards
     and some at91 boards are not yet ported to DT.
2) we decided to move to the new clk implementations in multiple steps 
(one SoC
     family after another) in order to ease PATCH review.

If we change the drivers to avoid specific clock name request 
([devm]_clk_get(dev, NULL)),
we will have to change the old static clk lookup tables
(i.e. 
http://lxr.free-electrons.com/source/arch/arm/mach-at91/at91sam9g45.c#L226,
http://lxr.free-electrons.com/source/arch/arm/mach-at91/at91sam9260.c#L202, 
...).

Best Regards,

Boris

> 	Arnd

