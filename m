Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJYSsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:48:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:50856 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJYSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:48:44 -0400
Date: Sat, 25 Oct 2014 10:34:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
In-Reply-To: <544AABB8.10302@codeaurora.org>
Message-ID: <alpine.DEB.2.11.1410251033270.5308@nanos>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com> <alpine.DEB.2.11.1410211120430.5308@nanos> <544628BF.8010809@arm.com> <CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com>
 <544A936D.5040409@arm.com> <544AABB8.10302@codeaurora.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Stephen Boyd wrote:

> On 10/24/2014 10:59 AM, Marc Zyngier wrote:
> > Hi Bjorn,
> >
> > On 24/10/14 18:31, Bjorn Andersson wrote:
> >>
> >> Stephen Boyd talked about the need to be able to mask/unmask interrupts from
> >> client code in the Qualcomm platform as well - most likely to block wakeup
> >> sources(?)
> > What's wrong with irq_disable?
> 
> The problem is irq_disable() is lazy and doesn't actually disable the
> interrupt.

Nothing prevents you from adding your own irq_disable() callback for
those interrupts. Just the default is lazy.

Thanks,

	tglx
