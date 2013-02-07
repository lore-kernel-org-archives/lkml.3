Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab3BGQMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:12:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873Ab3BGQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:12:04 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=1VwvDSosexF8QB732s0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360253520.2621.66.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 07 Feb 2013 11:12:00 -0500
In-Reply-To: <20130207111025.GD8945@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <20130207111025.GD8945@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 12:10 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'll reply to this as I come up with comments.
> > 
> > First thing is, don't call it NO_HZ_FULL. A better name would 
> > be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we 
> > totally remove jiffies :-)
> 
> I don't think we want yet another config option named in a 
> weird way.
> 
> What we want instead is to just split NO_HZ up into its 
> conceptual parts:
> 
>    CONFIG_NO_HZ_IDLE
>    CONFIG_NO_HZ_USER_SPACE
>    CONFIG_NO_HZ_KERNEL_SPACE
> 
> Where the current status quo is NO_HZ_IDLE=y, and Frederic is 
> about to introduce NO_HZ_USER_SPACE=y. When jiffies get removed 
> we get NO_HZ_KERNEL_SPACE=y.

Saying NO_HZ_USER_SPACE is a bit of a misnomer. As we don't just stop
the tick for user space, but it may remained stopped when entering the
kernel. The rule is that when there's just a single task on a CPU, the
tick can stop (no scheduling work needed). But if the task triggers
something that may require a tick (like printk) then the tick will start
again. But just going into the kernel does not designate a tick restart.

Maybe a better name would be NO_HZ_SINGLE_TASK ?

> 
> The 'CONFIG_NO_HZ' meta-option, which we should leave for easy 
> configurability and for compatibility, should get us the 
> currently recommended default, which for the time being might 
> be:
> 
>    CONFIG_NO_HZ_IDLE=y
>    # CONFIG_NO_HZ_USER_SPACE is disabled
> 
> Btw., you could add CONFIG_NO_HZ_KERNEL_SPACE right away, just 
> keep it false all the time. That would document our future plans 
> pretty well.

Maybe the removal of jiffies would be NO_HZ_COMPLETE?


-- Steve


