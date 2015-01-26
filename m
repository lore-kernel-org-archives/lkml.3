Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbbAZMvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:51:46 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43100 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbAZMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:51:43 -0500
Message-ID: <54C63856.7010704@arm.com>
Date: Mon, 26 Jan 2015 12:51:34 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, Thomas Gleixner <tglx@linutronix.de>
CC: "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v3 0/3] irqchip: vf610-mscm: add support for MSCM
 interrupt router
References: <1421309046-22452-1-git-send-email-stefan@agner.ch> <alpine.DEB.2.11.1501261115300.5526@nanos> <36990c90fa3d2ee0849227f31cbafb54@agner.ch>
In-Reply-To: <36990c90fa3d2ee0849227f31cbafb54@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 11:55, Stefan Agner wrote:
> On 2015-01-26 11:16, Thomas Gleixner wrote:
>> On Thu, 15 Jan 2015, Stefan Agner wrote:
>>
>>> Splitted out version of the MSCM driver. My first driver based on the
>>> routeable domain support and was part of the Vybrid Cortex-M4 support
>>> patchset.
>>>
>>> So far the MSCM interrupt router was initialized by the boot loader
>>> and configured all interrupts for the Cortex-A5 CPU. There are two
>>> use cases where a proper driver is necessary:
>>> - To run Linux on the Cortex-M4. When the kernel is running on the
>>>   non-preconfigured CPU, the interrupt router need to be configured
>>>   properly.
>>> - To support deeper sleep modes: LPSTOP clears the interrupt router
>>>   configuration, hence a driver needs to restore the configuration
>>>   on resume.
>>> I created a seperate patchset for that driver which hopefully makes
>>> it easier to get it into mergeable state.
>>>
>>> Since I identified some registers likely to be used by other drivers
>>> (e.g. CPU ID or the CPU Generate Interrupt Register) I also added
>>> the "syscon" compatible string to make the registers available for
>>> other drivers in case needed.
>>>
>>> This resend version of this patchset is rebased on v3.19-rc4.
>>
>> Has the discussion with Marc on the original V3 set been resolved?
> 
> There was no answer to the original v3 patch. The comments of Marc was
> back in the v2 set, and has been resolved in v3. However, no Ack from
> Marc so far.

That's just me being lazy ;-). For the series:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
