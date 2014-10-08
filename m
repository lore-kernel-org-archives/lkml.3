Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaJHPDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:03:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:38294 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaJHPDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:03:34 -0400
Date: Wed, 8 Oct 2014 17:03:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lina Iyer <lina.iyer@linaro.org>
cc: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
In-Reply-To: <20140925155027.GG1004@ilina-mac.local>
Message-ID: <alpine.DEB.2.11.1410081623210.4292@nanos>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org> <1409170479-29955-4-git-send-email-lina.iyer@linaro.org> <alpine.DEB.2.10.1408272239190.3323@nanos> <20140902184305.GB91995@ilina-mac.local> <alpine.DEB.2.10.1409022109050.3333@nanos>
 <20140925155027.GG1004@ilina-mac.local>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Lina Iyer wrote:
> > How would a general "keep track of the targets of all interrupts in
> > the system" mechanism make use of this? 
> Sorry, I do not understand your question.
> PM QoS is only interested in the IRQs specified in the QoS request. If
> there are no requests that need to be associated with an IRQ, then PM
> QoS will not register for an affinity change notification.

Right, and I really hate the whole per irq notifier. It's a rats nest
of life time issues and other problems.
 
It also does not tell you whether an irq is disabled, reenabled or
removed, which will change the qos constraints as well unless you
plaster all drivers with updates to qos for those cases.

So what about adding a qos field to irq_data itself, have a function
to update it and let the irq core keep track of the per cpu irq
relevant qos constraints and provide an evaluation function or a
notifier for the PM/idle code?

That's going to need some serious thought as well, but it should avoid
most of the nasty notifier and lifetime issue which the per irq
notifiers provide.

Thoughts?

	tglx





