Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaAaTsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:48:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:56242 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:48:52 -0500
Message-ID: <52EBFE1D.4020201@linutronix.de>
Date: Fri, 31 Jan 2014 20:48:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work
 to do
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>	<20140131120757.594e24d6@gandalf.local.home>	<20140131174227.GN9012@linux.vnet.ibm.com>	<20140131125719.73340f6e@gandalf.local.home>	<52EBF8FE.3080608@linutronix.de> <20140131143441.478f79ee@gandalf.local.home>
In-Reply-To: <20140131143441.478f79ee@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 08:34 PM, Steven Rostedt wrote:
> There's flags that determine when the next call should be invoked. The
> irq_work_run() should return immediately if it was already done by the
> arch specific call. The work wont be called twice.

Well, it is called twice. It just does nothing because the list is
empty & returns.

> As I have worked on code that uses irq_work() I can say that we want
> the arch specific interrupts. For those architectures that don't have
> it will experience larger latencies for the work required. It's
> basically, a "too bad" for them.

How "bad" is it? Is this something generic or just not getting
perf events fast enough out? Most users don't seem to require small
latencies.

> But to answer your question, no we want the immediate response.
> 
> -- Steve

Sebastian
