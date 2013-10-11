Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3JKOEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:04:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:65346 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3JKOEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1081,1371106800"; 
   d="scan'208";a="409454058"
Message-ID: <1381500268.19281.19.camel@empanada>
Subject: Re: [PATCH v10 04/12] tracing: Add 'snapshot' event trigger command
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 09:04:28 -0500
In-Reply-To: <52580157.1040300@hitachi.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
	 <4ed13a4c303b83164992b92dc17d79717bea2116.1381445299.git.tom.zanussi@linux.intel.com>
	 <52580157.1040300@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 22:47 +0900, Masami Hiramatsu wrote:
> (2013/10/11 9:48), Tom Zanussi wrote:
> >  /**
> > + * tracing_alloc_snapshot - allocate snapshot buffer.
> > + *
> > + * This only allocates the snapshot buffer if it isn't already
> > + * allocated - it doesn't also take a snapshot.
> > + *
> > + * This is meant to be used in cases where the snapshot buffer needs
> > + * to be set up for events that can't sleep but need to be able to
> > + * trigger a snapshot.
> > + */
> > +int tracing_alloc_snapshot(void)
> > +{
> > +	struct trace_array *tr = &global_trace;
> > +	int ret;
> > +
> > +	ret = alloc_snapshot(tr);
> > +	WARN_ON(ret < 0);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
> 
> Out of curiously, why this symbol is exported to modules?
> The functions which are called directly from trace_event macros
> should be exported because those macros can be used in module code,
> but I couldn't find this in such code, at a glance.
> 

tracing_alloc_snapshot() goes along with tracing_snapshot() and
tracing_snapshot_alloc() which are already exported - you should be able
to take a snapshot from a module, or do a combined snapshot/alloc or
(now) just the alloc.

Tom

> Thank you,
> 
> 
> 


