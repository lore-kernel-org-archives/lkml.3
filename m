Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaCLSCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:02:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:21745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754337AbaCLSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:02:06 -0400
Date: Wed, 12 Mar 2014 14:02:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140312140202.455f4037@gandalf.local.home>
In-Reply-To: <1078215147.1512.1394642450993.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140311142650.GB13756@redhat.com>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
	<20140311114023.02fcf639@gandalf.local.home>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
	<20140311151357.077c5a68@gandalf.local.home>
	<1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
	<20140312111100.42ea41c2@gandalf.local.home>
	<1078215147.1512.1394642450993.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 16:40:51 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
 
> > Please tell me one in-tree user that will be impacted?
> 
> I'm talking about all users of tracepoints, all in tree and out of tree
> users. We need the design and API for tracepoint to stay sound, and for that
> we need to study carefully the impact of the changes you propose on module
> load/unload scenarios.

Right now the current change actually fixes a bug. It tells the tracing
utility that the tracepoint that was to be enabled was or wasn't.


> > And the distribution just magically installs itself onto a computer? No,
> > a user does, and in doing so, they set up udev. A person installing a
> > distribution is a sysadmin. Even if it's grandma installing it herself.
> > She owns the box, no one else is doing anything for her (unless it's
> > your grandma).
> 
> In a corporate environment, it's pretty much never the end user who ends
> up being the system administrator of his machine.

And they shouldn't be tracing their modules. That should be up to the
corporate system administrators.


> > Tracing is a root privilege.
> 
> Tracing the kernel should require root privilege for the process interacting
> with the kernel ABI, I agree with that part. However, the end user of the
> machine should not need to be in a root shell to interact with tracing. For
> instance, if the tracer only provides summarized information pinpointing
> issues, the system administrator could very well allow the end user to use
> tracing without being root.
> 
> An example of this is the way laptops nowadays handle wifi connexions through
> a root daemon setting up the network (interfacing with kernel ABI), but which
> gets the user interaction though a user interface running in user context.

This is all out of scope with the latest proposal, so I will ignore it.

 
> > This seems very specific to a single tracing tool that happens not to
> > be in the kernel tree.
> 
> And the reason for that is because the said kernel community has been deaf to
> the requirements of the user-base we target. Unlike Ftrace, we are not targeting
> kernel developers, and unlike perf, we are not targeting sampling use-cases. Yes,
> there is a partial infrastructure overlap, but LTTng has been rejected on the
> ground of "fear of work duplication" which, frankly, makes no sense, since we are
> targeting different use cases. Some of the infrastructure work needs to be done
> in common, and some of the work needs to go in different directions.

Honestly, LTTng has been rejected because the maintainer of it tends to
sacrifice everything else to make tracing better.


> > 
> > Why would grandma want to trace the kernel?
> 
> Perhaps because her kernel crashes and she hates to lose the emails she is
> writing to her grandchildren when the crash happens, and because there is a
> nice tool that allow her to click "yes, I want to report issues to my
> favorite Linux distribution", which will then analyze the trace report and
> come up with an automated kernel upgrade a few weeks later.

A distro could set something like this up, with todays tools. If
grandma needed to start tracing, it was already too late for her to get
a report.



> > I actually never said that. I said that you could have a proxy to
> > enable or disable the tracepoint. I don't know where you're getting
> > this crap from. Yes, I have suggested in the past that the ideal
> > approach is to have modprobe handle it, just like it handles other
> > module changes for one time deals. And yes, tracing a module is a one
> > time deal. But you seem to be getting in a tizzy thinking that's what I
> > recommended yesterday.
> 
> This was the logical consequence of your recommendation of having a root proxy
> daemon to handle this.

You read too much into what I say. Like the "No signed-off-by". I was
actually telling you that tracepoints should not be enabled by non root
unless there was a daemon to control it. We both got off an tangents.


> > I wouldn't want people to have access to any box I own to be able to
> > just stick any usb device into the computer. Look at all the USB drivers
> > we have. You think they are all perfect. I'm sure it wouldn't be too
> > hard to find a bad USB device driver and make your own dongle to stick
> > in, that can root the box.
> 
> Yes, no code is perfect, and that includes USB drivers. But in that line of
> reasoning, why bother about security at all ? Since the ssh server code is
> imperfect, you might as well publish your private key. Sorry, this line of
> reasoning makes no sense.

ssh code is a small set of code compared to the thousands of random usb
drivers, including several that are in staging, that still happen to be
turned on by distros.


> > Have your LTTNg module dictate that policy.
> 
> I'm OK with that, as long as the tracepoint infrastructure itself is consistent.

We're working on that.

 
> > Hmm, currently the probe lies to the user when the tracepoint doesn't
> > exist. We enable it and nothing happens. This BROKE IN TREE USERS!!!!
> 
> The root of the original problem here was that tracepoint.c was skipping
> non-signed modules without printing any error. We added an printk error
> message for this.

Yes, but it still lies to the internal user in this case. Which is
wrong.

> 
> > 
> > I suggest that we remove the probe when the module is unloaded. No
> > lying. Either a tracepoint exists when you enable it, or it doesn't.
> 
> See other leg of this thread for the "high signal/noise" ratio technical
> discussion.
> 
> > 
> > 
> > > 
> > > B) Making tracepoint_probe_register() just return an error (-ENOEDV), but
> > >    leaving the probe registered.
> > > 
> > > I think we have already agreed that this compromise solution is a weird API
> > > choice, since an error condition must be treated as a success by the
> > > caller.
> > > Moreover, it has the same issue as (A) above: if the module is unloaded
> > > after probe registration, the tracer is lying to the user, making them
> > > think there is a call site loaded when there are none.
> > 
> > But isn't that what we do today?
> 
> No, currently tracepoint offers no API to query the state of tracepoint callsites
> other than the seqfile iterator (which I proposed to removed in a RFC patch
> yesterday).

To me that's a work around, not a real fix.

> 
> > 
> > > 
> > > C) Adding module load arguments to specify which tracepoint should be
> > >    enabled.
> > > 
> > > Please refer to my response above in this email to understand why I object.
> > 
> > I didn't suggest this in this thread. I only pointed out that is the
> > most sane situation. But I've been trying to work with you, and you
> > don't seem to see that.
> 
> I appreciate the compromise efforts you have made, but my points here are about
> sound design/API, and I have technical concerns still unanswered (see other leg
> of the thread). This is not about what LTTng needs, but about keeping the
> tracepoint API consistent.

Yep, see my responses.


> I don't mind doing the heavy lifting in LTTng at all. My concern here
> is (again) about keeping the tracepoint API semantically consistent when
> module load/unload occur. A lot of thinking went into this when I initially
> created tracepoint.c, and I don't want it to be degraded by a change that is
> not thought thoroughly.

I have a good idea of what needs to be done. I just need you to look at
things with a different perspective than what you are use to.

-- Steve
