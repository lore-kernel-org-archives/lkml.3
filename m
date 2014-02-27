Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaB0RG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:06:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:54585 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752823AbaB0RG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:06:26 -0500
Date: Thu, 27 Feb 2014 12:06:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are
 not loaded due to module taint
Message-ID: <20140227120624.051e2a99@gandalf.local.home>
In-Reply-To: <1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com>
References: <20140227154616.703252665@goodmis.org>
	<20140227154923.563572071@goodmis.org>
	<1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 16:33:50 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > -	if (trace_module_has_bad_taint(mod))
> > +	if (trace_module_has_bad_taint(mod)) {
> > +		pr_err("Module '%s' is tainted, disabling tracepoints\n",
> 
> Hrm, I wonder if this message could confuse users into thinking that because
> of this error, tracepoints are disabled across the entire kernel (rather than
> within this module).
> 
> I'd recommend the following message instead:
> 
>  pr_err("Module '%s' is tainted, ignoring its tracepoints\n",
> 

Sure. Will update.

-- Steve
