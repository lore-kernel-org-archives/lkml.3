Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3BRLQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:16:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:53607 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3BRLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:16:44 -0500
Date: Mon, 18 Feb 2013 12:16:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim.sander@hbm.com>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RCU?: Scheduling while atomic with 3.4.23-rt33
In-Reply-To: <4738617.pBMCEJ5E3K@dabox>
Message-ID: <alpine.LFD.2.02.1302181214250.22263@ionos>
References: <4738617.pBMCEJ5E3K@dabox>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Tim Sander wrote:
> Here is a transtribed backtrace for easier reading:
> c0010fac t dump_backtrace
> c022c188 T dump_stack
> c022c71c t __schedule_bug
> c022fb28 t __schedule
> c0230644 t rt_spin_lock_slowlock
> c0230ba8 T rt_spin_lock
> c003a9b8 T __wake_up
> c0052a44 t invoke_rcu_callbacks
> c0053764 T rcu_check_callbacks
> c0026060 T update_process_times

That's due to CONFIG_TINY_PREEMPT_RCU=y. That's a known issue, which
has been fixed in 3.6-rt.

Steven, could you backport that to 3.2/3.4 please ?

Thanks,

	tglx
