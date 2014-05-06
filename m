Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaEFVGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:06:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:44829 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754960AbaEFVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:06:42 -0400
Date: Tue, 6 May 2014 17:06:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
Message-ID: <20140506170640.088df53b@gandalf.local.home>
In-Reply-To: <799562553.12242.1399409621298.JavaMail.zimbra@efficios.com>
References: <20140506094407.507b6435@gandalf.local.home>
	<1033323713.12184.1399404932965.JavaMail.zimbra@efficios.com>
	<20140506154845.43c7b0ad@gandalf.local.home>
	<799562553.12242.1399409621298.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 20:53:41 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> > I do plan on adding more documentation to this to stress that this
> > should be done like this. But hey, we're kernel developers, we should
> > be responsible enough to not require the hand holding.
> 
> I like your optimism. ;-)

I'm always the optimist :-)

> > The first time I thought about using this was with David's code, which
> > does this:
> > 
> > 	if (static_key_false(&i2c_trace_msg)) {
> > 		int i;
> > 		for (i = 0; i < ret; i++)
> > 			if (msgs[i].flags & I2C_M_RD)
> > 				trace_i2c_reply(adap, &msgs[i], i);
> > 		trace_i2c_result(adap, i, ret);
> > 	}
> > 
> > That would look rather silly in a tracepoint.
> 
> Which goes with a mandatory silly question: how do you intend mapping
> the single key to two different tracepoints ?

Could always do:

	if (trace_i2c_result_enabled() || trace_i2c_reply_enabled()) {

I wounder what the assembly of that would look like.

Still, having "side-effects" in the tracepoint parameters just seems
odd to me.

- Steve
