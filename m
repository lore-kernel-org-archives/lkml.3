Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaCMStn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:49:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:14100 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754729AbaCMStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:49:42 -0400
Message-ID: <1394736566.26600.23.camel@pippen.local.home>
Subject: Re: [PATCH v6 4/7] arm64: Add ftrace support
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
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
Date: Thu, 13 Mar 2014 14:49:26 -0400
In-Reply-To: <20140313183705.GK25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
	 <20140313170834.GE25472@mudshark.cambridge.arm.com>
	 <1394735259.26600.14.camel@pippen.local.home>
	 <20140313183705.GK25472@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 18:37 +0000, Will Deacon wrote:
>  
> > No, return_hooker is consistent with all the other archs. Hey, it's a
> > rugby position! Note, which I was when I played. ;-)
> 
> Hehe, in which case your children will be able to execute that line of
> ftrace!
> 

My kids already know I was :-)

> > > 
> > > > +       trace.func = self_addr;
> > > 
> > > in kernel/ftrace/ftrace.c there's an smb_wmb() between setting up
> > > tracing_graph_pause and setting the ret_stack with a comment saying:
> > > 
> > >     /* Make sure the tasks see the -1 first: */
> > > 
> > > Why don't we have a corresponding read-barrier here?
> > 
> > The corresponding rmb is in kernel/trace/trace_function_graph
> > ftrace_push_return_trace().
> 
> Okey doke then, I guess we don't really care about tracing_graph_pause
> getting out-of-sync with curr_ret_stack.

Yep, the tracing_graph_pause is more to prevent crazy stuff happening
when an interrupt comes in. So it is just local cpu context, and doesn't
have issues with other CPUS. If it takes a bit for the task to see it go
to zero, the worse thing is that you might miss a few tracing functions
until that gets synced. Which will probably happen by the time tracing
is fully activated anyway.

-- Steve


