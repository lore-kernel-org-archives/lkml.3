Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832AbaDJJBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:01:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47536 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933236AbaDJJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:01:39 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Rob Herring <robherring2@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "heiko.stuebner\@bq.com" <heiko.stuebner@bq.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
In-Reply-To: <CAL_JsqJowqV2bsxE2VeYXQQSj4_L_KcH+C_dD=ZUvC=1crN4dA@mail.gmail.com>
	(Rob Herring's message of "Wed, 9 Apr 2014 22:50:33 +0100")
Organization: ARM Ltd
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
	<1397072736-10793-4-git-send-email-matthias.bgg@gmail.com>
	<CAL_JsqJowqV2bsxE2VeYXQQSj4_L_KcH+C_dD=ZUvC=1crN4dA@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 10 Apr 2014 10:01:28 +0100
Message-ID: <87ha6136dz.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of things on top of Rob's comments:

On Wed, Apr 09 2014 at 10:50:33 pm BST, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Apr 9, 2014 at 2:45 PM, Matthias Brugger <matthias.bgg@gmail.com> wrote:
>> This adds a generic devicetree board file and a dtsi for boards
>> based on the MT6589 SoCs from Mediatek.
>>
>> Apart from the generic parts (gic, clocks) the only component
>> currently supported are the timers.
>>
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

[...]

>> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
>> new file mode 100644
>> index 0000000..c0139ca
>> --- /dev/null
>> +++ b/arch/arm/mach-mediatek/Kconfig
>> @@ -0,0 +1,14 @@
>> +config ARCH_MEDIATEK
>> +       bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
>> +       select ARCH_REQUIRE_GPIOLIB
>
> Then where is your GPIO driver?
>
>> +       select ARM_GIC
>> +       select CACHE_L2X0
>> +       select HAVE_ARM_TWD if LOCAL_TIMERS

Hell no! ;-) ARM_ARCH_TIMER is the way (please also add the missing
node).

>> +       select HAVE_SMP
>
> Not needed now (going into 3.15).
>
>> +       select LOCAL_TIMERS if SMP

No, A7 always have the arch timers.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
