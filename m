Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3KTLnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:43:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:60986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3KTLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:43:03 -0500
Date: Wed, 20 Nov 2013 12:42:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, patches@linaro.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, tj@kernel.org, mingo@redhat.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john.stultz@linaro.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [RFC] Timer: Migrate running timers
In-Reply-To: <3a0ef8e5a838fcf1a3cdaecc029cc97dea5edf65.1384940804.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1311201148272.30673@ionos.tec.linutronix.de>
References: <3a0ef8e5a838fcf1a3cdaecc029cc97dea5edf65.1384940804.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Wed, 20 Nov 2013, Viresh Kumar wrote:

> Migration of timers from idle cores to non-idle ones for power saving is very
> well working and really saves a lot of power for us. What's currently not
> working is the migration of running timers Or timers which re-arms themselves.
>
> There are complications with migrating timers which schedules themselves again
> from their handler. del_timer_sync() can't detect that the timer's handler
> yet has not finished.

Because you try to violate the semantics of the existing code. There
is a reason why we enforce that running timers must be requeued on the
base they are running on.

Now you try to duct tape it into submission. That's not going to fly.

The timer wheel code is not designed to allow that and it has lots of
other short comings and historic burdens. I'm not going to accept more
duct tape and fragile hackery into that code.

I'm already working on a complete replacement infrastructure, which
avoids all the short comings of the current timer implementation
including this one. 

It's going to be a massive effort to convert everything over to the
new infrastructure so we can kill the timer wheel, but that's less
scary and less risky than trying to add more fragility to the existing
code.

Thanks,

	tglx



	    
