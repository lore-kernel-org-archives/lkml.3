Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaEWUgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:36:48 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35385 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaEWUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405231047050.9995@ionos.tec.linutronix.de>
References: <1400776606-22427-1-git-send-email-f.fainelli@gmail.com>
 <1400776606-22427-2-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.02.1405231047050.9995@ionos.tec.linutronix.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 23 May 2014 13:36:04 -0700
Message-ID: <CAGVrzcYk9Py_PWeW+jRgMg6NNioVkVVWmdSebnB9f139tt23cg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] irqchip: add Broadcom Set Top Box Level-2
 interrupt controller
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-22 18:51 GMT-07:00 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 22 May 2014, Florian Fainelli wrote:
>> +static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
>> +{
>> +     struct brcmstb_l2_intc_data *b = irq_desc_get_handler_data(desc);
>> +     struct irq_chip *chip = irq_get_chip(irq);
>
> irq_desc_get_chip() is what you want here. irq_get_chip() is doing a
> full lookop of desc, which is silly as you have desc already.

Thanks, is there anything else that needs fixing before I submit a v3? Thanks!
-- 
Florian
