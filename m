Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3GLJ46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:56:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60199 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab3GLJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:56:57 -0400
Date: Fri, 12 Jul 2013 11:56:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
Message-ID: <20130712095600.GT25631@dyad.programming.kicks-ass.net>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
 <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 04:12:18PM +0300, Adrian Hunter wrote:
> The event stream is not always parsable because the format of a sample
> is dependent on the sample_type of the selected event.  When there
> is more than one selected event and the sample_types are not the
> same then parsing becomes problematic.  A sample can be matched to its
> selected event using the ID that is allocated when the event is opened.
> Unfortunately, to get the ID from the sample means first parsing it.
> 
> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
> the ID at a fixed position so that the ID can be retrieved without
> parsing the sample.  For sample events, that is the first position
> immediately after the header.  For non-sample events, that is the last
> position.

There's events where this isn't a possible location; take PERF_RECORD_MMAP for
instance; the tail is the complete filename.

Why not always insert right after the header?

Also; you forgot to update include/uapi/linux/perf_event.h:enum perf_event_type
That's the format documentation.
