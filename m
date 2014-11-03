Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaKCNMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:12:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbaKCNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:11:59 -0500
Date: Mon, 3 Nov 2014 14:11:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/7] perf tools: Enhance the thread stack to output
 call/return data
Message-ID: <20141103131111.GB29906@krava.brq.redhat.com>
References: <1414678188-14946-1-git-send-email-adrian.hunter@intel.com>
 <1414678188-14946-5-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414678188-14946-5-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 04:09:45PM +0200, Adrian Hunter wrote:
> Enhance the thread stack to output detailed information
> about paired calls and returns.
> 
> The enhanced processing consumes sample information via
> thread_stack__process() and outputs information about
> paired calls / returns via a call-back.  While the
> call-back makes it possible for the facility to be used
> by arbitrary tools, a subsequent patch will provide the
> information to Python scripting via the db-export
> interface.
> 
> An important part of the call/return information is the
> call path which provides a structure that defines a context
> sensitive call graph.
> 
> Note that there are now two ways to use the thread stack.
> For simply providing a call stack (like you would get
> from the perf record -g option) the interface consists of
> thread_stack__event() and thread_stack__sample().  Whereas
> the enhanced interface consists of call_return_processor__new()
> and thread_stack__process().

the interface seems pretty separated, with clear in and out values,
so it should be fairly easy to write automated tests for that ;-)

also given that there's no real user of this interface at the moment,
it'd be really nice to have ;-) anyway

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka
