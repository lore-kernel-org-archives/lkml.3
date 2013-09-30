Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3I3O2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:28:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60962 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3I3O2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:28:40 -0400
Message-ID: <52498A94.7090009@arm.com>
Date: Mon, 30 Sep 2013 15:28:36 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sricharan R <r.sricharan@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>, "rnayak@ti.com" <rnayak@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH 1/6] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable
 irqs
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-2-git-send-email-r.sricharan@ti.com> <524987A3.4090204@arm.com> <5249890B.7020906@ti.com>
In-Reply-To: <5249890B.7020906@ti.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 30 Sep 2013 14:28:37.0172 (UTC) FILETIME=[59C95740:01CEBDE9]
X-MC-Unique: 113093015283800201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/13 15:22, Santosh Shilimkar wrote:
> On Monday 30 September 2013 10:16 AM, Marc Zyngier wrote:
>> On 30/09/13 14:59, Sricharan R wrote:
>>> In some socs the gic can be preceded by a crossbar IP which
>>> routes the peripheral interrupts to the gic inputs. The peripheral
>>> interrupts are associated with a fixed crossbar input line and the
>>> crossbar routes that to one of the free gic input line.
>>>
>>> The DT entries for peripherals provides the fixed crossbar input line
>>> as its interrupt number and the mapping code should associate this with
>>> a free gic input line. This patch adds the support inside the gic irqchip
>>> to handle such routable irqs. The routable irqs are registered in a linear
>>> domain. The registered routable domain's callback should be implemented
>>> to get a free irq and to configure the IP to route it.
>>
>> Isn't this just another chained interrupt controller? How is it GIC
>> specific?
>>
> No it isn't a irq controller rather a event router. Patch is missing
> reference to the previous discussion. Previous discussion is here [1]
> 
> Regards,
> Santosh
> 
> [1] https://lkml.org/lkml/2013/9/13/413

Right. I need to go and understand that bit first.

Thanks Santosh.

	M.
-- 
Jazz is not dead. It just smells funny...

