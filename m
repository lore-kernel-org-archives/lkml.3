Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3FUG7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:59:47 -0400
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:40966 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758606Ab3FUG7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:59:45 -0400
Message-ID: <51C3F9DD.5040709@overkiz.com>
Date: Fri, 21 Jun 2013 08:59:41 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
CC: Wim Van Sebroeck <wim@iguana.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH 0/4] watchdog: at91sam9_wdt: handle already configured
 wdt
References: <1370947890-954-1-git-send-email-b.brezillon@overkiz.com> <B256D81BAE5131468A838E5D7A243641687DE078@penmbx01>
In-Reply-To: <B256D81BAE5131468A838E5D7A243641687DE078@penmbx01>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18016087360286849157
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/2013 03:47, Yang, Wenyou wrote:
>
>> -----Original Message-----
>> From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org]
>> On Behalf Of Boris BREZILLON
>> Sent: 2013Äê6ÔÂ11ÈÕ 18:51
>> To: Wim Van Sebroeck; Jean-Christophe Plagniol-Villard; Ferre, Nicolas;
>> linux-watchdog@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org; linux-doc@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Boris
>> BREZILLON
>> Subject: [RFC PATCH 0/4] watchdog: at91sam9_wdt: handle already configured
>> wdt
>>
>> Hello,
>>
>> This patch series is a porposal to enhance the sam9 watchdog timer support.
>>
>> The at91sam9 watchdog timer cannot configured twice, and the current
>> implementation only tries to configure in a static way:
>> - 2 seconds timeout
>> - wdt restart every 500ms
>>
>> If the timer has already been configured with different values, it returns an
>> error and do not create any watchdog device.
>>
>> This is not critical if the watchdog is disabled, but if it has been enabled with
>> different timeout values it will lead to a SoC reset.
>>
>> This patch series tries to address this issue by adapting the heartbeat value
>> according the WDT timer config:
>> - it first tries to configure the timer as requested.
>> - if it fails it fallbacks to the current config, adapting its heartbeat timer
>> to the needs
>>
>> This patch series also move to a dynamically allocated at91wdt device instead
>> of the static instance. I'm not sure this is the best solution, so please tell
>> me if you prefer to keep static instance of watchdog.
>>
>> It adds a new at91 wdt type: software. This new type make use of the at91 wdt
>> interrupt to trigger a software watchdog.
>>
>> Finally it adds several properties to the device tree bindings.
>>
>> Best Regards,
>> Boris
>>
>> Boris BREZILLON (4):
>>   watchdog: at91sam9_wdt: better watchdog support
>>   watchdog: at91sam9_wdt: update device tree doc
>>   ARM: at91/dt: add sam9 watchdog default options to SoCs
>>   ARM: at91/dt: add watchdog properties to kizbox board
>>
>>  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 +-
>>  arch/arm/boot/dts/at91sam9260.dtsi                 |    5 +
>>  arch/arm/boot/dts/at91sam9263.dtsi                 |    5 +
>>  arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
>>  arch/arm/boot/dts/at91sam9n12.dtsi                 |    5 +
>>  arch/arm/boot/dts/at91sam9x5.dtsi                  |    5 +
>>  arch/arm/boot/dts/kizbox.dts                       |    6 +
>>  arch/arm/boot/dts/sama5d3.dtsi                     |    5 +
>>  drivers/watchdog/at91sam9_wdt.c                    |  319
>> +++++++++++++++-----
>>  9 files changed, 300 insertions(+), 85 deletions(-)
>>
>> --
>> 1.7.9.5
>>
>>
> Tested on sama5d34ek, at91sam9g25ek, linux-next_20130620
>
> Tested by Wenyou Yang <Wenyou.yang@atmel.com>
>
Thanks for your tests and review.

Best Regards,

Boris
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

