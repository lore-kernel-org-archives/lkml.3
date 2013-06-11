Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3FKMld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:41:33 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40844 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3FKMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:41:32 -0400
Message-ID: <51B71AF6.1090108@gmail.com>
Date: Tue, 11 Jun 2013 14:41:26 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Marvell Orion SoC irqchip and clocksource
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130611123521.GA3996@localhost>
In-Reply-To: <20130611123521.GA3996@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 14:35, Ezequiel Garcia wrote:
> On Thu, Jun 06, 2013 at 06:27:08PM +0200, Sebastian Hesselbarth wrote:
>> This patch set introduces DT-aware irqchip and clocksource drivers for
>> Marvell Orion SoCs (Kirkwood, Dove, Orion5x, MV78x00) and corresponding
>> patches for Dove and Kirkwood to enable them for DT-boards.
>>
>> The irqchip driver, of course, depends on Thomas Gleixner's work on
>> irqdomain support for generic chip (tip irq/core).
>>
>> The ARM part of this patch set has a quite ridiculuous dependency havoc
>> of mv643xx_eth DT support (current net-next) that will add to both irqchip
>> and clocksource branches respectively. Therefore, I suggest that irq
>> and clocksource maintainers take in the mere drivers (Patches 1+2) and
>> Jason Cooper handles the remaining patches when all three drivers have
>> surfaced on mainline linux.
>>
[...]
>> Sebastian Hesselbarth (6):
>>    irqchip: add support for Marvell Orion SoCs
>>    clocksource: add Marvell Orion SoC timer
>>    ARM: dove: move device tree nodes to DT irqchip and clocksource
>>    ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
>>    ARM: dove: convert to DT irqchip and clocksource
>>    ARM: kirkwood: convert to DT irqchip and clocksource
>>
>
> I've done some tests on my Kirkwood Openblocks A6 using the latest
> branch orion-irqchip-for-v3.11-v4. Everything works fine so:
>
> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Ezequiel, thanks for testing!

> For patches 3 to 6 I'm wondering if there's any reason why the irqchip and
> clocksource changes are not separated. I'm probably being too picky but,
> unless you have a good reason for having them together,
> I think they should go separated, i.e. patches for irqchip on one side,
> and patches for clocksource on the other.

The only reason is that when switching from current non-irqdomain irq
controller to irqdomain-based above, there is no 1:1 mapping between
irq numbers and hwirqs anymore. But you are right, for the ARM part
patches that will be merged first thing when v3.11-rc1 is out, the
correct order is mv643xx_eth, clocksource, irqchip.

I will prepare new, rebased patches for Jason Cooper then anyway.

With Thomas Gleixner's Review now only somebody has to take the irqchip
patch then all three drivers are queued for next release.

Sebastian
