Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaEFVQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:16:42 -0400
Received: from mail.efficios.com ([78.47.125.74]:37667 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaEFVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:16:40 -0400
Date: Tue, 6 May 2014 21:16:40 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <1813175652.12255.1399411000693.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140506170640.088df53b@gandalf.local.home>
References: <20140506094407.507b6435@gandalf.local.home> <1033323713.12184.1399404932965.JavaMail.zimbra@efficios.com> <20140506154845.43c7b0ad@gandalf.local.home> <799562553.12242.1399409621298.JavaMail.zimbra@efficios.com> <20140506170640.088df53b@gandalf.local.home>
Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Add trace_<tracepoint>_enabled() function
Thread-Index: Ic9qJsRIb36KQYxvZg5yro5HjySKrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Javi Merino"
> <javi.merino@arm.com>, "David Howells" <dhowells@redhat.com>, "Ingo Molnar" <mingo@kernel.org>
> Sent: Tuesday, May 6, 2014 5:06:40 PM
> Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
> 
> On Tue, 6 May 2014 20:53:41 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
[...]
> 
> > > The first time I thought about using this was with David's code, which
> > > does this:
> > > 
> > > 	if (static_key_false(&i2c_trace_msg)) {
> > > 		int i;
> > > 		for (i = 0; i < ret; i++)
> > > 			if (msgs[i].flags & I2C_M_RD)
> > > 				trace_i2c_reply(adap, &msgs[i], i);
> > > 		trace_i2c_result(adap, i, ret);
> > > 	}
> > > 
> > > That would look rather silly in a tracepoint.
> > 
> > Which goes with a mandatory silly question: how do you intend mapping
> > the single key to two different tracepoints ?
> 
> Could always do:
> 
> 	if (trace_i2c_result_enabled() || trace_i2c_reply_enabled()) {
> 
> I wounder what the assembly of that would look like.

I would expect it to generate two static jump sites back to back.

> 
> Still, having "side-effects" in the tracepoint parameters just seems
> odd to me.

I agree that the "enabled" static inline approach is more flexible. So
if we document it well enough, it might be OK in the end.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
