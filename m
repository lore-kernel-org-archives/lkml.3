Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaCMSkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:40:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57099 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbaCMSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:40:12 -0400
Date: Thu, 13 Mar 2014 18:37:05 +0000
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/7] arm64: Add ftrace support
Message-ID: <20140313183705.GK25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
 <20140313170834.GE25472@mudshark.cambridge.arm.com>
 <1394735259.26600.14.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394735259.26600.14.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 06:27:39PM +0000, Steven Rostedt wrote:
> On Thu, 2014-03-13 at 17:08 +0000, Will Deacon wrote:
> 
> > > +       /*
> > > +        * Note:
> > > +        * No protection against faulting at *parent, which may be seen
> > > +        * on other archs. It's unlikely on AArch64.
> > > +        */
> > > +       old = *parent;
> > > +       *parent = return_hooker;
> > 
> > return_hook? People might take it personally otherwise ;)
> 
> No, return_hooker is consistent with all the other archs. Hey, it's a
> rugby position! Note, which I was when I played. ;-)

Hehe, in which case your children will be able to execute that line of
ftrace!

> > 
> > > +       trace.func = self_addr;
> > 
> > in kernel/ftrace/ftrace.c there's an smb_wmb() between setting up
> > tracing_graph_pause and setting the ret_stack with a comment saying:
> > 
> >     /* Make sure the tasks see the -1 first: */
> > 
> > Why don't we have a corresponding read-barrier here?
> 
> The corresponding rmb is in kernel/trace/trace_function_graph
> ftrace_push_return_trace().

Okey doke then, I guess we don't really care about tracing_graph_pause
getting out-of-sync with curr_ret_stack.

Will
