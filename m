Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaCLQkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:40:49 -0400
Received: from mail.efficios.com ([78.47.125.74]:50956 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbaCLQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:40:46 -0400
Date: Wed, 12 Mar 2014 16:40:51 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <1078215147.1512.1394642450993.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312111100.42ea41c2@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <20140311142650.GB13756@redhat.com> <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com> <20140311114023.02fcf639@gandalf.local.home> <1752080128.130.1394559263621.JavaMail.zimbra@efficios.com> <20140311151357.077c5a68@gandalf.local.home> <1501695915.977.1394634294978.JavaMail.zimbra@efficios.com> <20140312111100.42ea41c2@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: eyaUx7cPEDiy5hGs/j/22JzxJop6Vg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(FYI, this is the leg of the thread that can be considered lower signal/noise
ratio if the underlying arguments are not interesting to you. If they are, please
read on!) :-)

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>
> Sent: Wednesday, March 12, 2014 11:11:00 AM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Wed, 12 Mar 2014 14:24:54 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > ----- Original Message -----
> > > From: "Steven Rostedt" <rostedt@goodmis.org>
> > > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > > Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
> > > "Ingo Molnar" <mingo@kernel.org>, "Frederic
> > > Weisbecker" <fweisbec@gmail.com>, "Andrew Morton"
> > > <akpm@linux-foundation.org>, "Johannes Berg"
> > > <johannes.berg@intel.com>
> > > Sent: Tuesday, March 11, 2014 3:13:57 PM
> > > Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
> > > set via debugfs
> > > 
> > 
> > For those just added in CC, https://lkml.org/lkml/2014/3/11/431 provides
> > the
> > missing context. The discussion is about adding module load parameters as
> > ABI
> > for end users to enable tracepoints in modules (Steven has proposed the
> > idea
> > a couple of times in the past, I am against for the reasons I am exposing
> > below). This discussion will likely have deep impact on other changes
> > Steven
> > is proposing for tracepoint.c (such as making tracepoint_probe_register()
> > return -ENODEV when no tracepoint call site is currently loaded for a given
> > tracepoint), so I think the audience should be broadened.
> 
> Please tell me one in-tree user that will be impacted?

I'm talking about all users of tracepoints, all in tree and out of tree
users. We need the design and API for tracepoint to stay sound, and for that
we need to study carefully the impact of the changes you propose on module
load/unload scenarios.

> 
> > 
> > > On Tue, 11 Mar 2014 17:34:23 +0000 (UTC)
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > >  
> > > > > Who can load modules not as root?? That is utterly broken. As once
> > > > > you
> > > > > can load a module, YOU ARE ROOT.
> > > > 
> > > > udevd runs as root, and listens to events such as USB hotplug, and
> > > > loads
> > > > modules
> > > > in the back of users. The users don't need to be root for this to
> > > > happen.
> > > 
> > > udevd may run as a proxy for users. But it is still a root user.
> > > Sysadmins are the ones that set up udevd.
> > 
> > Uh ? There are tons of distributions that setup udevd for their users, and
> > no sysadmin has to interact with it.
> 
> And the distribution just magically installs itself onto a computer? No,
> a user does, and in doing so, they set up udev. A person installing a
> distribution is a sysadmin. Even if it's grandma installing it herself.
> She owns the box, no one else is doing anything for her (unless it's
> your grandma).

In a corporate environment, it's pretty much never the end user who ends
up being the system administrator of his machine.

> 
> > 
> > > If you own your own box, you are technically the sysadmin for it.
> > 
> > If you use a box owned by your company, running Linux, but enforcing module
> > signature, you might be physically allowed to connect USB devices, and let
> > udevd load the appropriate modules for the connected devices, but that does
> > not mean you have root access at all. But having the ability to trace the
> > said computer from a user having "tracing" privileges is very valuable to
> > help debugging that machine.
> 
> Tracing is a root privilege.

Tracing the kernel should require root privilege for the process interacting
with the kernel ABI, I agree with that part. However, the end user of the
machine should not need to be in a root shell to interact with tracing. For
instance, if the tracer only provides summarized information pinpointing
issues, the system administrator could very well allow the end user to use
tracing without being root.

An example of this is the way laptops nowadays handle wifi connexions through
a root daemon setting up the network (interfacing with kernel ABI), but which
gets the user interaction though a user interface running in user context.

> 
> > 
> > Even without going that far, if you want tracing to be widely usable to
> > pinpoint issues within Linux and/or its applications or libraries, you
> > basically have to remove most user interactions from the picture, and let
> > automated tools gather tracing data to perform analysis. As soon as you
> > require users to fiddle with udev configuration, or pass special parameters
> > to modprobe, or if you start coupling the tracing infrastructure with the
> > module configuration, you just made tracing unusable for a vast majority of
> > Linux distribution users out there.
> 
> This seems very specific to a single tracing tool that happens not to
> be in the kernel tree.

And the reason for that is because the said kernel community has been deaf to
the requirements of the user-base we target. Unlike Ftrace, we are not targeting
kernel developers, and unlike perf, we are not targeting sampling use-cases. Yes,
there is a partial infrastructure overlap, but LTTng has been rejected on the
ground of "fear of work duplication" which, frankly, makes no sense, since we are
targeting different use cases. Some of the infrastructure work needs to be done
in common, and some of the work needs to go in different directions.

> 
> > 
> > I've been trying to make my point that tracing should be first of all
> > _usable_ by non-expert Linux end users, but it seems that I'm completely
> > failing at getting the message through somehow. And believe me I've spent
> > years trying to voice this message. Perhaps I'm not cursing enough, perhaps
> > I'm not yelling enough. Rather than arguing, the path I'm currently taking
> > is to prove my point by putting the tools needed by my user community in
> > their hands.
> 
> I don't know why you are complaining. Think of this as your job
> security.

I think the tension that exists in the Linux tracing community is not helping
progress at all in this area. This is why I'm trying to re-open the dialogue.

> 
> > 
> > If to you the majority of Linux users means "kernel developers", then
> > I can see how our point of views cannot be reconciled easily. From my
> > point of view, there are far more users who need those tracing tools that
> > are not kernel developers.
> 
> No, but the majority of tracing users *are* kernel developers, or those
> that are experts in the system.

Is it that way because the current tracing tools are so unusable by
non kernel-developers that those are the only ones able to interact with
those tools ?

You seem to mix "knowledge needed to make sense of a trace" with "knowledge
needed to gather a trace". The first kind of knowledge can be put into
analysis tools, but they cannot be used widely if gathering a trace requires
people to be kernel experts too.

> 
> Why would grandma want to trace the kernel?

Perhaps because her kernel crashes and she hates to lose the emails she is
writing to her grandchildren when the crash happens, and because there is a
nice tool that allow her to click "yes, I want to report issues to my
favorite Linux distribution", which will then analyze the trace report and
come up with an automated kernel upgrade a few weeks later.

> 
> > 
> > > Modifications to udev require sudo
> > > privileges.
> > > 
> > > Tracepoints should not be something a non-sysadmin can modify or
> > > enable. If you want non root users to do so, create a proxy daemon like
> > > udevd to do it for them. But the kernel isn't going to allow that
> > > directly.
> > 
> > I never said the kernel should directly expose ABIs accessible by others
> > than root. Actually, this is the very reason we have a "lttng-sessiond"
> > daemon running as root to control kernel tracing. However, it can be
> > controlled by a "lttng" command line tool over unix sockets if the user
> > is part of the "tracing" group. Right there, this is the concept of your
> > proxy daemon. However, you seem to imply that this proxy daemon should
> > somehow fiddle with udevd and/or modprobe configuration to add temporary
> > system-wide parameters to how modules are loaded, depending on tracing
> > needs. Trying to couple something usually configured initially for a
> > large portion of a system's life (and even with tripwire validation that
> > /etc does not change over time) with something as transient as tracing
> > simply cannot work without causing havoc in the system configuration. So
> > no, having a tracing proxy daemon changing configuration of module
> > arguments cannot fly.
> 
> I actually never said that. I said that you could have a proxy to
> enable or disable the tracepoint. I don't know where you're getting
> this crap from. Yes, I have suggested in the past that the ideal
> approach is to have modprobe handle it, just like it handles other
> module changes for one time deals. And yes, tracing a module is a one
> time deal. But you seem to be getting in a tizzy thinking that's what I
> recommended yesterday.

This was the logical consequence of your recommendation of having a root proxy
daemon to handle this.


> 
> > 
> > > 
> > > > 
> > > > >  
> > > > > > fashion and is not suitable for the user-base we are targeting. I
> > > > > > seems
> > > > > > to
> > > > > > be a user experience disaster IMHO.
> > > > > 
> > > > > For your case only. But it is normal operation for normal uses of
> > > > > Linux.
> > > > 
> > > > AFAIK pretty much all distros use udev nowadays. Are you suggesting
> > > > that
> > > > all
> > > > users using udev and distribution kernels are not "normal uses of
> > > > Linux" ?
> > > 
> > > udev is root, and is modified by root users. A normal user can not just
> > > interact with udev. And sticking in a usb stick into a computer counts
> > > as a sysadmin operation, even if the person doesn't official have the
> > > title.
> > 
> > So if I understand your line of thought, you imply that anyone who can
> > plug a USB stick of any kind (memory stick, USB wifi card, etc) into a
> > computer should automatically have root access ? Is it just me, or it
> > makes no sense ?
> 
> I wouldn't want people to have access to any box I own to be able to
> just stick any usb device into the computer. Look at all the USB drivers
> we have. You think they are all perfect. I'm sure it wouldn't be too
> hard to find a bad USB device driver and make your own dongle to stick
> in, that can root the box.

Yes, no code is perfect, and that includes USB drivers. But in that line of
reasoning, why bother about security at all ? Since the ssh server code is
imperfect, you might as well publish your private key. Sorry, this line of
reasoning makes no sense.

> 
> > 
> > > 
> > > > 
> > > > > 
> > > > > > 
> > > > > > I'm OK as long as we have an elegant way forward. Ideally I would
> > > > > > have
> > > > > > prefered (1) to eliminate code duplication between tracers and
> > > > > > tracepoint
> > > > > > infrastructure (we have to reimplement a hash table similar to
> > > > > > tracepoints
> > > > > > within the tracer with solution (2)), but (2) technically works
> > > > > > too.
> > > > > 
> > > > > Here's what I propose then. We implement 2 for now. You can
> > > > > "duplicate"
> > > > > the code into your own work.
> > > > 
> > > > Works for me.
> > > > 
> > > > > Then we should be able to simplify the
> > > > > tracepoint code as it no longer will have the requirement to enable
> > > > > tracepoints that do not exist.
> > > > 
> > > > What happens for the case where we enable a tracepoint, and then the
> > > > only module containing a callsite of that tracepoint is unloaded, and
> > > > then reloaded ?
> > > 
> > > When a module is unloaded, it usually loses state. Is there any state
> > > that is maintained for a module being unloaded and reloaded again?
> > > Besides tracepoints? If not, then the module should lose its state for
> > > tracepoints as well.
> > 
> > What you're missing here is that the same tracepoint can appear within
> > more than one module.
> 
> So?
> 
> > 
> > I think there is a core, fundamental difference between the ways we see
> > tracing. You seem to see tracing as being solely part of the modules
> > that contain the caller tracing code. From my perspective, tracing fits
> > much better in the "aspect oriented programming" paradigm, since it spreads
> > the same "crosscutting concerns" across multiple modules. So yes, in AOP,
> > it makes perfect sense that tracing activation state goes beyond the
> > lifetime of a single loaded module: it spawns across core kernel, and zero,
> > one, or more loaded modules, independently of whether they are unloaded and
> > reloaded again.
> 
> Have your LTTNg module dictate that policy.

I'm OK with that, as long as the tracepoint infrastructure itself is consistent.

> 
> > 
> > 
> > So going back on the changes you proposed to the tracepoint infrastructure:
> > 
> > A) Making tracepoint_probe_register() unregister the probe and fail when
> >    there is no tracepoint call site present for a probe at that time:
> > 
> > With this approach, if the probe is registered when the module containing
> > the call site is loaded, and then that module is unloaded, it will leave
> > the probe in a registered state, leaving the tracer lying to the user,
> > letting them think there are currently callsites for this tracepoint when
> > there are none.
> 
> Hmm, currently the probe lies to the user when the tracepoint doesn't
> exist. We enable it and nothing happens. This BROKE IN TREE USERS!!!!

The root of the original problem here was that tracepoint.c was skipping
non-signed modules without printing any error. We added an printk error
message for this.

> 
> I suggest that we remove the probe when the module is unloaded. No
> lying. Either a tracepoint exists when you enable it, or it doesn't.

See other leg of this thread for the "high signal/noise" ratio technical
discussion.

> 
> 
> > 
> > B) Making tracepoint_probe_register() just return an error (-ENOEDV), but
> >    leaving the probe registered.
> > 
> > I think we have already agreed that this compromise solution is a weird API
> > choice, since an error condition must be treated as a success by the
> > caller.
> > Moreover, it has the same issue as (A) above: if the module is unloaded
> > after probe registration, the tracer is lying to the user, making them
> > think there is a call site loaded when there are none.
> 
> But isn't that what we do today?

No, currently tracepoint offers no API to query the state of tracepoint callsites
other than the seqfile iterator (which I proposed to removed in a RFC patch
yesterday).

> 
> > 
> > C) Adding module load arguments to specify which tracepoint should be
> >    enabled.
> > 
> > Please refer to my response above in this email to understand why I object.
> 
> I didn't suggest this in this thread. I only pointed out that is the
> most sane situation. But I've been trying to work with you, and you
> don't seem to see that.

I appreciate the compromise efforts you have made, but my points here are about
sound design/API, and I have technical concerns still unanswered (see other leg
of the thread). This is not about what LTTng needs, but about keeping the
tracepoint API consistent.

> 
> > 
> > Back to your original requirement: you want to let the tracer communicate
> > to end users whether a specific tracepoint has call sites or not. I'm
> > currently preparing a patch implementing a "tracepoint_callsite_count()"
> > API that will allow this, and it won't lie to the tracer like solutions
> > (A) and (B) above. Whenever the tracer queries the state, it will get the
> > current information about the number of enabled call sites, not some stale
> > data based on a prior registration error.
> 
> No, I don't want to know if this call site exists or not. This stupid
> "tracepoint_probe_register()" that activates a tracepoint by name. But
> if that tracepoint doesn't exist, it just returns normally as if
> everything is fine and dandy. WTF!
> 
> Look Mathieu, I've been trying to be nice here. This crap has broken
> in tree kernel users, and this magical "enable a non-existent
> tracepoint, so when one is created, it will be enabled" is only used by
> LTTng! NOBODY ELSE USES IT. This means that I can strip this usage out
> of the kernel, as there are no uses of it in the kernel.
> 
> What you don't seem to realize, is that your methods broke the stuff
> that is in the kernel, and you don't seem to give a shit about that.
> 
> The solution I like the most that I believe will work for both of us,
> is to to move this magic "enable tracepoint in the future" to your
> LTTng module. Have your module register a module load and unload handler
> to be able to see the tracepoints that exist in the module, and you can
> enable them then. When a module is unloaded, your module can do the
> accounting to record that, and the state of its tracepoints.
> 
> Looks like we can have it both ways. A way that works well for the
> kernel, and a way that works well for you. But your module will need to
> do the heavy work for what you want.
> 
> To me, a tracepoint should only be enabled when it exists. If it is
> enabled in module when the module is unloaded, then it should be
> removed after the module has left. If the module is loaded again, it is
> up to the user (or your module) to enable that tracepoint again.

I don't mind doing the heavy lifting in LTTng at all. My concern here
is (again) about keeping the tracepoint API semantically consistent when
module load/unload occur. A lot of thinking went into this when I initially
created tracepoint.c, and I don't want it to be degraded by a change that is
not thought thoroughly.

Thanks,

Mathieu


> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
