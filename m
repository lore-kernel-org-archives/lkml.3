Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaELKTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:19:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:49842 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaELKTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:19:01 -0400
Date: Mon, 12 May 2014 12:19:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, daniel.lezcano@linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC 1/2] clockevents: return 'int' from
 clockevents_set_mode()
In-Reply-To: <df571ff25b510bd0263b194bfdcbaf1b476a2a03.1399886467.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1405121140210.6261@ionos.tec.linutronix.de>
References: <cover.1399886467.git.viresh.kumar@linaro.org> <df571ff25b510bd0263b194bfdcbaf1b476a2a03.1399886467.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Viresh Kumar wrote:
> clockevents_set_mode() calls dev->set_mode() which has return type of 'void'
> currently. Later patches would add another interface dev->set_dev_mode(), which
> will return int and clockevents_set_mode() must propagate failures returned from
> it.
> 
> This patch changes prototype of clockevents_set_mode() to return 'int' and fix
> caller sites as well. As most of the call sites maynot work if
> clockevents_set_mode() fails, do issue a WARN() on failures. All other are
> updated to return error codes.

Is this a speed coding contest? And did you even think about what I
suggested:

if (dev->set_dev_mode) {
   ret = dev->set_dev_mode(dev, mode);
   handle_return_value(ret);
   
Does that handle_return_value() mean that you sprinkle WARN_ONs all
over the place? Does it mean, that you change the return value
semantics of functions which happen to call clock_events_set_mode()
just because it now has a return value?

Hell no.

handle_return_value() means handle the return value right there. We
know what we want to set and we know what may fail and what not, so we
can explicitely WARN right there. And for those things which might
fail, we return the failure and handle it at the call site. 

I've warned you and I'm seriosly grumpy by now. You are just wasting
my time and I'm tired of that.

Find someone competent who reviews your patches, deals with you and
when they make sense sends them to me. Or just stay away from kernel/*
and find something else to wreckage.

Thanks,

	tglx
