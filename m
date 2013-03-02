Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3CBNXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:23:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:39779 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3CBNXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:23:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="293914784"
Date: Sat, 2 Mar 2013 21:23:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christopher Li <sparse@chrisli.org>
Subject: Re: [trace:tip/perf/core 5/15] kernel/trace/trace_functions.c:79:16:
 sparse: incorrect type in initializer (different address spaces)
Message-ID: <20130302132330.GA15256@localhost>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
 <1362229972.31874.7.camel@gandalf.local.home>
 <1362230122.31874.8.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362230122.31874.8.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 08:15:22AM -0500, Steven Rostedt wrote:
> On Sat, 2013-03-02 at 08:12 -0500, Steven Rostedt wrote:
> 
> > Hmm, actually it seems to be complaining everywhere but in trace.c which
> > is where the per_cpu was allocated. Do I need to annotate the trace.h
> > header to specify (at least to sparse) that the pointer is allocated per
> > cpu?
> 
> I guess I need this patch:

That's it!  Verified with

        make C=1 kernel/trace/trace_functions.o

Thanks,
Fengguang

> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index c597523..50a9c81 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -198,7 +198,7 @@ struct trace_array {
>         struct list_head        systems;
>         struct list_head        events;
>         struct task_struct      *waiter;
> -       struct trace_array_cpu  *data;
> +       struct trace_array_cpu __percpu *data;
>  };
>  
>  enum {
> 
> -- Steve
> 
