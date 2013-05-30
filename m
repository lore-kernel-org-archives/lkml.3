Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3E3N5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:57:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:33516 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3E3N51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:57:27 -0400
Date: Thu, 30 May 2013 15:57:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Bohac <jbohac@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] nohz: Prevent broadcast source from stealing full dynticks
 timekeeping duty
In-Reply-To: <1369845580-15273-2-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.02.1305301554100.2905@ionos>
References: <1369845580-15273-1-git-send-email-fweisbec@gmail.com> <1369845580-15273-2-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Frederic Weisbecker wrote:

> The timekeeping duty is currently assigned to the CPU that
> handles the tick broadcast clock device by the time it is set in
> one shot mode.
> 
> The reason for this is not entirely clear as outlined by Jiri
> Bohac: https://patchwork.kernel.org/patch/2302951/
> 
> One could speculate though that it makes sure only one CPU
> is woken up to fixup the timekeeping max deferment. But the
> timekeeper can change anytime after the broadcast CPU becomes
> idle. So probably we can remove this as in Jiri's patch, but
> not late in the -rc's.

Looking at commit 7300711e (clockevents: broadcast fixup possible
waiters) which introduced that takeover, I really can't see a reason
why we must do that. It's safe to remove it completely even now.

Thanks,

	tglx




