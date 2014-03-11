Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaCKC6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:58:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:19278 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754422AbaCKC6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:58:22 -0400
Date: Mon, 10 Mar 2014 22:58:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140310225820.0f02025d@gandalf.local.home>
In-Reply-To: <y0mr469e9t0.fsf@fche.csb>
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
	<y0mr469e9t0.fsf@fche.csb>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 22:41:31 -0400
fche@redhat.com (Frank Ch. Eigler) wrote:

> 
> Hi -
> 
> 
> >> From: Steven Rostedt <rostedt@goodmis.org>
> >> 
> >> Tracepoints were made to allow enabling a tracepoint in a module before that
> >> module was loaded. When a tracepoint is enabled and it does not exist, the
> >> name is stored and will be enabled when the tracepoint is created.
> >> 
> >> The problem with this approach is that when a tracepoint is enabled when
> >> it expects to be there, it gives no warning that it does not exist.
> 
> So it is a deferred-activation kind of call, with no way of knowing
> when or if the tracepoints will start coming in.  Why is that
> supported at all, considering that clients could monitor modules
> coming & going via the module_notifier chain, and update registration
> at that time?

That's my argument.

> 
> 
> >> +	entry = get_tracepoint(name);
> >> +	/* Make sure the entry was enabled */
> >> +	if (!entry || !entry->enabled)
> >> +		ret = -ENODEV;
> 
> For what it's worth, I agree with Mathieu that this sort of successful
> failure result code is a problem for tracking what needs cleanup and
> what doesn't.  (In systemtap's case, if this change gets merged, we'll
> have to treat -ENODEV as if it were 0.)

Does systemtap enable tracepoints before they are created? That is, do
you allow enabling of a tracepoint in a module that is not loaded yet?

If not, than you want this as an error.

-- Steve
