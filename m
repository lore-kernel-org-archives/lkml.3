Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3GLOzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:55:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36322 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3GLOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:55:35 -0400
Date: Fri, 12 Jul 2013 16:55:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
Message-ID: <20130712145515.GI17211@twins.programming.kicks-ass.net>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
 <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
 <20130712095600.GT25631@dyad.programming.kicks-ass.net>
 <51DFFCE1.1070203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DFFCE1.1070203@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 03:56:01PM +0300, Adrian Hunter wrote:
> > There's events where this isn't a possible location; take PERF_RECORD_MMAP for
> > instance; the tail is the complete filename.
> 
> PERF_RECORD_MMAP falls in the category I have called non-sample events.
> Those events are appended with an ID sample.  perf tools parses the ID
> sample backwards from header.size.  So the ID is at the last position
> relative to header.size

But why? Why make it different per PERF_RECORD type? 
