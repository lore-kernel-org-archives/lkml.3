Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3BRTt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:49:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3BRTt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:49:27 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dna11aX-Ae4A:10 a=2AvaQ2u3cyaRZxchUbkA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361216963.23152.168.camel@gandalf.local.home>
Subject: Re: prctl(PR_SET_MM)
From: Steven Rostedt <rostedt@goodmis.org>
To: u3557@dialix.com.au
Cc: Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 14:49:23 -0500
In-Reply-To: <20130218163359.25760592076@miso.sublimeip.com>
References: <20130218163359.25760592076@miso.sublimeip.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 03:33 +1100, Amnon Shiloh wrote:

> Yes, Randy Dunlap already raised this point, but I have no dealings with
> any particular Linux distribution or the right connections to chase them
> all, one by one - I develop generic software for the general Linux community,
> that is intended to work distribution-independently.  Even if I had access
> to all distributions, it may be hard to convince them to configure
> CONFIG_CHECKPOINT_RESTORE as a whole since it contains so much other code.

If only you, or a few people are using it (ie. distros don't see a
need), then it will be up to you to make the changes.

> 
> BTW, Can anyone explain this policy of "have things default n"?
> When I go over "init/Kconfig" or most other Kconfig's, I can
> actually see lots of "default y".

Linus stated that he doesn't want any new feature default on, unless it
gives better performance to the general populace. Because someone's old
config should not add new features when they use it for a new kernel.
Basically, if something is default on, then it probably shouldn't have a
config for it.

Some are on because they were always on (although several were changed
to 'n'). Also it's fine to have a default y that depends on something
that is default n, if it makes sense.

For example, the function graph tracer is default y, but requires the
function tracer to be enabled which is default n. This is because I
assumed that you would want the function graph tracer if you enabled
function tracing, as the graph tracer gives much more information.

> 
> > 
> > > 2) Releasing this code from the "#ifdef CONFIG_CHECK_RESTORE"; or
> > > 3) Placing this code within a different kernel-configuration option
> > >    (say "CONFIG_BASIC_CHECKPOINTING") that is enabled by default; or
> > > 4) Placing this code under a dual #if, so instead of:
> > >    #ifdef CONFIG_CHECKPOINT_RESTORE
> > > 	   have:
> > >    #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_BASIC_CHECKPOINTING)
> > 
> > One of the above 3 can probably be worked out.
> > 
> > -- Steve
> 
> Great!
> 
> Naturally I prefer option 2 (but the other two will do as well).

I have no problems with this out of line.

-- Steve


