Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3I3OQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:16:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49476 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3I3OQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:16:09 -0400
Message-ID: <524987A3.4090204@arm.com>
Date: Mon, 30 Sep 2013 15:16:03 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>, "rnayak@ti.com" <rnayak@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [RFC PATCH 1/6] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable
 irqs
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-2-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1380549564-31045-2-git-send-email-r.sricharan@ti.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 30 Sep 2013 14:16:04.0338 (UTC) FILETIME=[990FFD20:01CEBDE7]
X-MC-Unique: 113093015160603101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/13 14:59, Sricharan R wrote:
> In some socs the gic can be preceded by a crossbar IP which
> routes the peripheral interrupts to the gic inputs. The peripheral
> interrupts are associated with a fixed crossbar input line and the
> crossbar routes that to one of the free gic input line.
> 
> The DT entries for peripherals provides the fixed crossbar input line
> as its interrupt number and the mapping code should associate this with
> a free gic input line. This patch adds the support inside the gic irqchip
> to handle such routable irqs. The routable irqs are registered in a linear
> domain. The registered routable domain's callback should be implemented
> to get a free irq and to configure the IP to route it.

Isn't this just another chained interrupt controller? How is it GIC
specific?

	M.
-- 
Jazz is not dead. It just smells funny...

