Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3LJMBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:01:53 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:44504 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3LJMBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:01:52 -0500
Date: Tue, 10 Dec 2013 09:01:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
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
Message-ID: <20131210120143.GJ8098@ghostprotocols.net>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210111229.GB26659@gmail.com>
 <20131210114421.GI8098@ghostprotocols.net>
 <20131210114757.GC29875@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210114757.GC29875@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 10, 2013 at 12:47:57PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Em Tue, Dec 10, 2013 at 12:12:29PM +0100, Ingo Molnar escreveu:
> > > Hm, I've unpulled it because 'perf top' crashes on exit, in 
> > > dso__delete():

> > 495		if (dso->sname_alloc)
> > 496			free((char *)dso->short_name)

> Btw., instead of trusting flags I'd argue that using the pointer as a 
> flag and clearing the pointer too is a much more robust freeing 
> pattern in general:

> 		if (dso->short_name) {
> 			free(dso->short_name);
> 			dso->short_name = NULL;
> 		}
> 
> or so ...

This is not an unusual idiom, if you look at tools/perf/util/ev{list,sel}.c,
for instance, you'll see it in many destructors.

In this case there is a micro optimization where sometimes the shortname
is just a pointer to the tail part of the long name, hence the flag.

- Arnaldo
