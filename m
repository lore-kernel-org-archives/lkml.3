Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab3BGQpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:45:53 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59039 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BGQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <1360255280.2621.70.camel@gandalf.local.home>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<20130207111025.GD8945@gmail.com>
	<CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
	<1360255280.2621.70.camel@gandalf.local.home>
Date: Thu, 7 Feb 2013 17:45:50 +0100
Message-ID: <CAFTL4hy-hz=okOC7mWTwP=eh_OrL48c5hoLuXyBRFMAgquLCtw@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2013-02-07 at 17:25 +0100, Frederic Weisbecker wrote:
>
>> At least for now we seem to agree on CONFIG_NO_HZ_IDLE and keep
>> CONFIG_NO_HZ for compatibility. Are you ok with that? If so I'll send
>> a patch.
>
> I believe that Ingo was suggesting to have CONFIG_NO_HZ give options to
> what type of config NO_HZ you want. Something like:
>
> config NO_HZ
>         bool "Enable tickless support"
>
> config NO_HZ_IDLE
>         bool "Stop tick when CPU is idle"
>         default y
>         depends on NO_HZ

Sounds good!

>
> config NO_HZ_TASK
>         bool "Stop tick on specified CPUs when single task is running"
>         default n
>         depends on NO_HZ

Ok I launched another debate about that single task thing. I wish we
don't make it a fundamental component but rather an implementation
detail that can be dynamically dealt with in the future. Anyway let's
talk about that on my previous answer.

>
> That is, if you select NO_HZ, by default NO_HZ_IDLE is also selected.
> But in the kernel the NO_HZ_IDLE is used.

Yeah, nice idea!

>
> -- Steve
>
>
