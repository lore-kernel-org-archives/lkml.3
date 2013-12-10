Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LJNaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:30:01 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63489 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3LJN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:29:58 -0500
Date: Tue, 10 Dec 2013 10:29:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210132949.GN8098@ghostprotocols.net>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210111229.GB26659@gmail.com>
 <20131210114421.GI8098@ghostprotocols.net>
 <52A70558.90808@intel.com>
 <20131210121801.GC30001@gmail.com>
 <20131210124658.GA31256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210124658.GA31256@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 10, 2013 at 01:46:58PM +0100, Ingo Molnar escreveu:
> * Ingo Molnar <mingo@kernel.org> wrote:
> > Every time one runs into a crash like this it's a canary signal that 
> > cleanliness principles need hardening.
> 
> More observations about util/dso.c:
> 
>  - dso__binary_type_file() should probably pass in 'const struct dso'
> 
>  - dso__binary_type_file()'s filename string parameter should be named 
>    'filename', not 'file' ...
> 
>  - build_id__sprintf() looks fragile: every single use of it appears 
>    to follow this pattern:
> 
> 	build_id__sprintf(x, sizeof(x), ...)
> 
>    this could be simplified (and eliminating the possibility to typo a 
>    bug) by changing the function to __build_id__snprintf() and adding 
>    a build_id__sprintf() wrapper macro around it:
> 
> 	build_id__sprintf(x, ...)
> 
>    that generates the size itself.

Right, like:

int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
                                     struct perf_event_attr *attrs, size_t nr_attrs);

#define perf_evlist__add_default_attrs(evlist, array) \
        __perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))

This is all a matter of being more dilligent and judicious at employing
these and other good practices.

But don't be shy to point anything (like you did here), as time permits
we can go on doing patchkits to address things people notice.

- Arnaldo
