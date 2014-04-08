Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaDHToG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:44:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:14181 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbaDHToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:44:04 -0400
Date: Tue, 8 Apr 2014 15:44:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v10 1/1] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140408154401.03adc51d@gandalf.local.home>
In-Reply-To: <645268231.929.1396985754629.JavaMail.zimbra@efficios.com>
References: <1396620154-24542-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1396620154-24542-2-git-send-email-mathieu.desnoyers@efficios.com>
	<20140408135600.2f9f5f4f@gandalf.local.home>
	<645268231.929.1396985754629.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 19:35:54 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > 
> > > +{
> > > +	if (call->flags & TRACE_EVENT_FL_TRACEPOINT)
> > > +		return call->tp ? call->tp->name : NULL;
> > > +	else
> > > +		return call->name;
> > > +}
> > 
> > Also, you missed a bunch of conversions in trace_event.c file. Do a
> > search for '->name' and you'll find them. The ones that shouldn't be
> > converted are rather obvious (system, field, mod), but you'll see
> > others that were missed. I'm a bit nervous about what other ones may be
> > missed as well.
> 
> Got them. I noticed that I forgot to turn on CONFIG_DYNAMIC_FTRACE when
> I did the original swap from name to _name to find the sites to update.
> 
> I did test more recently with a config that has all the FTRACE and PERF
> features enabled, but that was after I swapped back from _name to name,
> so I did not catch those two sites.
> 
> I just swapped the field name to _name again, and did the build with
> all FTRACE and PERF config options enabled to be certain I did not miss
> any. Just to be extra sure, I'm doing a make allyesconfig too.
> 
> Then, I'm changing _name back to name, and I'll prepare this as v11.
> 
> Is that OK with you ?
> 

Maybe you want to build with an allmodconfig to make sure. You probably
did get everything, but just to be sure.

-- Steve
