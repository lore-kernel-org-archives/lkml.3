Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaJYTmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:42:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:51050 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaJYTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:42:13 -0400
Date: Sat, 25 Oct 2014 21:42:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be
 save/restored
In-Reply-To: <alpine.DEB.2.11.1410252131110.5308@nanos>
Message-ID: <alpine.DEB.2.11.1410252136220.5308@nanos>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com> <1414232097-4328-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252131110.5308@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Thomas Gleixner wrote:

Bah, hit send way too fast :)

> On Sat, 25 Oct 2014, Marc Zyngier wrote:
> > +int irq_get_irqchip_state(unsigned int irq, int state)

get_state(state) does not make sense. get_state(which) probably more
so. And 'which' wants to be an enum btw.

> > +	chip_bus_lock(desc);
> > +	val = chip->irq_get_irqchip_state(data, state);
> 
> Hmm. What's the irq_get_irqchip_state() callback supposed to return?

Either an error code or a boolean value, right? Does not mix very well
I think. 

int irq_get_irqchip_state(unsigned int irq, enum xxx which, bool *val)

Might be a more clear interface.

Thanks,

	tglx


