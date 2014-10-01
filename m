Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaJAWCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:02:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:38985 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaJAWCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,635,1406617200"; 
   d="scan'208";a="481360504"
Date: Wed, 1 Oct 2014 15:02:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Adding a filter to events (instead of replacing one) was Re:
 [PATCH 1/2] perf, tools: Add PERF_PID
Message-ID: <20141001220218.GC3264@tassilo.jf.intel.com>
References: <1411591869-325-1-git-send-email-andi@firstfloor.org>
 <20141001180316.GI2799@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001180316.GI2799@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:03:16PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 24, 2014 at 01:51:08PM -0700, Andi Kleen escreveu:
> 
> > It's currently difficult to filter out perf itself using a filter.
> > This can give cascading effects during IO tracing when the IO perf
> > does itself causes more trace output.
>  
> > The best way to filter is to use the pid. But it's difficult to get the pid
> > of perf without using hacks.
>  
> > Add a PERF_PID meta variable to the perf filter that contains the current pid.
>  
> > With this patch the following works
>  
> > % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...
> 
> So I tried this one now and saw the other patch, that applies the
> --filter to all events, while trying I got:

Patch seems reasonable to me.

However adding PERF_PID and sanitizing --filter are really two
different things and should probably not be mixed in a patch.

-Andi
