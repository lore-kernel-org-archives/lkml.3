Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946963Ab3BHTnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:43:55 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:2469 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946842Ab3BHTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:43:53 -0500
Date: Fri, 8 Feb 2013 19:43:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Clark Williams <williams@redhat.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
In-Reply-To: <20130208125747.06a1e260@riff.lan>
Message-ID: <0000013cbb55dcfd-8b269a51-2d60-44de-a0c5-1ccf9925782f-000000@email.amazonses.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com> <1360205415.2621.60.camel@gandalf.local.home> <CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com> <1360256447.2621.75.camel@gandalf.local.home>
 <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com> <0000013cb614e4e5-10f6e9ce-08e1-47f6-9044-565b4084c354-000000@email.amazonses.com> <CAFTL4hyfnhjezjL2QfVKYDB-bwh4BSGyX8xmhpdmxTf+EAu+yA@mail.gmail.com> <20130208125747.06a1e260@riff.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Clark Williams wrote:

> I was a little apprehensive when you started talking about multiple
> tasks in Adaptive NOHZ mode on a core but the more I started thinking
> about it, I realized that we might end up in a cooperative multitasking
> mode with no tick at all going. Multiple SCHED_FIFO threads could
> run until blocking and another would be picked. Depends on well
> behaved threads of course, so probably many cases of users shooting off
> some toes with this...
>
> Of course if you mix scheduling policies or have RT throttling turned
> on we'll need some sort of tick for preemption. But if we can keep the
> timer reprogramming down we may see some big wins for RT and HPC loads.

We could tune the (hr)timer tick to have the same interval as the time
slice interval for a process and make that constant for all processes on a
hardware thread?

