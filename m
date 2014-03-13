Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaCMS1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:27:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59470 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754690AbaCMS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:27:47 -0400
Message-ID: <1394735259.26600.14.camel@pippen.local.home>
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
Date: Thu, 13 Mar 2014 14:27:39 -0400
In-Reply-To: <20140313170834.GE25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-5-git-send-email-takahiro.akashi@linaro.org>
	 <20140313170834.GE25472@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 17:08 +0000, Will Deacon wrote:

> > +       /*
> > +        * Note:
> > +        * No protection against faulting at *parent, which may be seen
> > +        * on other archs. It's unlikely on AArch64.
> > +        */
> > +       old = *parent;
> > +       *parent = return_hooker;
> 
> return_hook? People might take it personally otherwise ;)

No, return_hooker is consistent with all the other archs. Hey, it's a
rugby position! Note, which I was when I played. ;-)

> 
> > +       trace.func = self_addr;
> 
> in kernel/ftrace/ftrace.c there's an smb_wmb() between setting up
> tracing_graph_pause and setting the ret_stack with a comment saying:
> 
>     /* Make sure the tasks see the -1 first: */
> 
> Why don't we have a corresponding read-barrier here?

The corresponding rmb is in kernel/trace/trace_function_graph
ftrace_push_return_trace().

-- Steve


