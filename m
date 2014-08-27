Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbaH0U4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:56:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:35965 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaH0U4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:56:44 -0400
Date: Wed, 27 Aug 2014 22:56:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lina Iyer <lina.iyer@linaro.org>
cc: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
In-Reply-To: <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
Message-ID: <alpine.DEB.2.10.1408272239190.3323@nanos>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org> <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Lina Iyer wrote:

> PM QoS and other idle frameworks can do a better job of addressing power
> and performance requirements for a cpu, knowing the IRQs that are
> affine to that cpu. If a performance request is placed against serving
> the IRQ faster and if the IRQ is affine to a set of cpus, then setting
> the performance requirements only on those cpus help save power on the
> rest of the cpus. PM QoS framework is one such framework interested in
> knowing the smp_affinity of an IRQ and the change notificiation in this
> regard. QoS requests for the CPU_DMA_LATENCY constraint currently apply
> to all cpus, but when attached to an IRQ, can be applied only to the set
> of cpus that IRQ's smp_affinity is set to. This allows other cpus to
> enter deeper sleep states to save power. More than one framework/driver
> can be interested in such information.

All you are describing is the fact, that there is only a single
notifier possible right now, but you completely miss to describe WHY
you need multiple ones.

The existing notifier was introduced to tell the driver that the irq
affinity has changed, so it can move its buffers to the proper NUMA
node. So if that driver gets this information then it can tell the PM
QoS code that its affinity changed so that stuff can react
accordingly, right?

This is going nowhere unless you provide a proper usecase and
arguments why this is necessary. Handwaving and I want a pony
arguments are not sufficient.

Thanks,

	tglx
