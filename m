Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaAGCvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:51:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:27052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167AbaAGCvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,616,1384329600"; 
   d="scan'208";a="462656051"
Message-ID: <1389063069.3040.90.camel@empanada>
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 20:51:09 -0600
In-Reply-To: <20140106205034.53c219cc@gandalf.local.home>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
	 <20140106161347.4cc82a4b@gandalf.local.home>
	 <1389055673.3040.83.camel@empanada>
	 <20140106205034.53c219cc@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > +	enum event_trigger_type tt = ETT_NONE;
> > > +
> > > +	if (__event_trigger_test_discard(file, buffer, event, entry, &tt))
> > > +		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
> > 
> > The logic is correct overall, but the way it reads is the opposite of
> > what it used to i.e. it should read 'if you don't discard the event,
> > then do the trace_buffer_unlock_commit' - it works as written because it
> > returns 1 if it didn't discard, which is confusing.
> 
> Hmm, OK, I think you may have convinced me. I'll swap the return values.
> 

Sounds great, thanks!

> I need to write up some trigger tests to make sure they work the same
> before and after this patch.
> 

I'll run the next version through my 'testsuite', which unfortunately is
still manual (one of the many things on my todo list is automate it)..

Tom



