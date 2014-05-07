Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaEGKIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:08:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:45374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEGKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:08:43 -0400
Date: Wed, 7 May 2014 12:08:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: john.stultz@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        jet.chen@intel.com
Subject: Re: [PATCH V2] clocksource: register cpu notifier to remove timer
 from dying CPU
In-Reply-To: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1405071203150.6261@ionos.tec.linutronix.de>
References: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014, Viresh Kumar wrote:
> This patch tries to fix this by registering cpu notifiers from clocksource core,
> only when we start clocksource-watchdog. And if on the CPU_DEAD notification it
> is found that dying CPU was the CPU on which this timer is queued on, then it is
> removed from that CPU and queued to next CPU.

Gah, no. We realy don't want more notifier crap.
  
It's perfectly fine for the watchdog timer to be moved around on cpu
down. And the timer itself is not pinned at all. add_timer_on() does
not set the pinned bit.

Thanks,

	tglx


