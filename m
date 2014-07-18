Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaGRCJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:09:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21132 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbaGRCJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:09:01 -0400
Date: Thu, 17 Jul 2014 22:08:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        =?ISO-8859-1?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Subject: Re: [PATCH-v2] tracing: Fix wraparound problems in "uptime" tracer
Message-ID: <20140717220849.735bec65@gandalf.local.home>
In-Reply-To: <CA+8MBbKgHqwzLbY17-6o_Y-EULatnXgTdgn2kUhhOabELYGV6w@mail.gmail.com>
References: <20140630144017.2abc48ba@gandalf.local.home>
	<b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
	<CA+8MBbKgHqwzLbY17-6o_Y-EULatnXgTdgn2kUhhOabELYGV6w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014 16:02:26 -0700
Tony Luck <tony.luck@gmail.com> wrote:

> On Mon, Jun 30, 2014 at 1:31 PM, Tony Luck <tony.luck@intel.com> wrote:
> > +#else
> > +       jiffy *= HZ_TO_NSEC_NUM;
> > +       do_div(jiffy, HZ_TO_NSEC_DEN);
> > +       return jiffy;
> > +#endif
> 
> Well that didn't work either.  kernel/trace/trace_clock.c doesn't include
> timeconst.h - so we fail the compile because HZ_TO_NSEC_{NUM,DEN}
> aren't defined.  a #include looks dicey because timeconst.h is a generated
> file up the the kernel/ level ... so getting Makefile dependencies right would
> be ugly.
> 
> Do we really need to convert to nanoseconds? Couldn't we just return
> jiffies:

Sure, and we can make it a "counter". That is, the counters don't hide
1000 counts on output.

> 
> u64 notrace trace_clock_jiffies(void)
> {
>        return jiffies_64 - INITIAL_JIFFIES;
> }
> 
> and leave it as an exercise to userspace to interpret that?
> 
> -Tony
> 
> [Yes, this changes the UI . but there can't be any serious users
> given that the existing UI only works for 1hr 11 minutes after each
> boot]

I doubt it will break any tools, so it's fine.

-- Steve

