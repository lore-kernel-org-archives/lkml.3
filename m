Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3K1KqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:46:07 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47749 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab3K1KqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:46:03 -0500
X-Sasl-enc: WMYT/uifD/ZiQYosA1iP2ldTXQTjGwWmwP5oZRlXhJc7 1385635561
Message-ID: <52971EE7.7070702@alexeicolin.com>
Date: Thu, 28 Nov 2013 05:45:59 -0500
From: Alexei Colin <alexei@alexeicolin.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, nicolas.pitre@linaro.org,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v3 0/4] Exynos 5410 Dual cluster support
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com> <1951315.Ol55YFu91h@flatron> <528CBF17.4020500@samsung.com>
In-Reply-To: <528CBF17.4020500@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 08:54 AM, Tarek Dakhran wrote:
> On 20.11.2013 03:23, Tomasz Figa wrote:
>> I've applied the patches on top of today's linux-next and tried to boot
>> my ODROID-XU using exynos5410-smdk5410.dts and exynos_defconfig, but all
>> I can get is an imprecise external abort, when the kernel tries to jump
>> to init. Full boot log below. Any ideas?

>> [    5.195000] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
>> [    5.210000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
>>
> Tomasz, there is CCI on/off switcher on smdk5410 board, also there is 
> XOMCCI pin on SoC.
> Looks like switcher on board controls the XOMCCI SoC pin.
> 
> When I turn switcher OFF, I getting the same problem you got.
> Please, check the cci state on Odroid-XU Board, maybe it is turned off.

I've soldered a wire to the XOMCCI pin on Odroid-XU+E. When pulled to
Vdd via 100k (original configuration), the fault is "imprecise external
abort (0x1406)" (as above). When pulled to ground, the fault is
"imprecise external abort (0x406)". This is consistently reproducible.

AFAICT, from ARM reference [1]: the 5 status bits in both cases are
"Asynchronous external abort." and the difference is bit 12 "external
abort type:" when pulled to Vdd, caused by "AXI Slave error," when
pulled to ground, caused by "AXI Decode error".

Any pointers on further differences between SMDK5410 and ODROID-XU that
are preventing the patch from booting? Thanks in advance.

[1]
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0344b/Bgbiaghh.html

