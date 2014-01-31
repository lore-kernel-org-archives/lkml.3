Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaAaT1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:27:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:56157 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbaAaT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:27:03 -0500
Message-ID: <52EBF8FE.3080608@linutronix.de>
Date: Fri, 31 Jan 2014 20:26:54 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work
 to do
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>	<20140131120757.594e24d6@gandalf.local.home>	<20140131174227.GN9012@linux.vnet.ibm.com> <20140131125719.73340f6e@gandalf.local.home>
In-Reply-To: <20140131125719.73340f6e@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 06:57 PM, Steven Rostedt wrote:

> In vanilla Linux, irq_work_run() is called from update_process_times()
> when it is called from the timer interrupt. In -rt, there's reasons we

and in vanilla Linux some architectures (like x86 or sparc to name just
a few) overwrite arch_irq_work_raise() which means they provide
their "own" interrupt like callback. That means on those architectures
irq_work_run() gets invoked twice: once via update_process_times() and
via and once the custom interface.
So my question to the original inventor of this code: Peter, do we
really need that arch specific callback? Wouldn't one be enough? Is it
that critical that it can't wait to the next timer tick?

Sebastian

