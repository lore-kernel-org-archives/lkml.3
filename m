Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3KMCtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:49:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38851 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KMCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:49:13 -0500
Date: Tue, 12 Nov 2013 18:48:25 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131113024825.GA21844@us.ibm.com>
References: <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
 <20131105094220.GA1071@krava.brq.redhat.com>
 <5278EE0A.1080108@intel.com>
 <20131105133024.GE1071@krava.brq.redhat.com>
 <20131105142545.GD22912@ghostprotocols.net>
 <20131105173152.GB7329@ghostprotocols.net>
 <20131108084001.GG19203@twins.programming.kicks-ass.net>
 <20131111120655.GC21291@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111120655.GC21291@gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111302-3532-0000-0000-000002F7E902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar [mingo@kernel.org] wrote:
| 
| * Peter Zijlstra <peterz@infradead.org> wrote:
| 
| > On Tue, Nov 05, 2013 at 02:31:52PM -0300, Arnaldo Carvalho de Melo wrote:
| > > PeterZ,
| > > 
| > > 	Can I have your Acked-by for this one? I guess now the goal is
| > > achieved, no?

Being able to profile children with the --pid is a big plus.

| > 
| > So this option allows -t/-p/-u to create one buffer per cpu and attach
| > all the various thread/process/user tasks' their counters to that one
| > buffer?
| > 
| > As opposed to the current state where each such counter would have its
| > own buffer.
| > 
| > If this is what the patch does, then yes, although I would prefer a
| > slightly clearer Changelog.
| > 
| > Acked-by: Peter Zijlstra <peterz@infradead.org>
| 
| Is there any reason why we wouldn't want to make this the default 
| behavior?
| 
| That way we could also lose the somewhat suboptimal 'force' naming: 
| there's nothing forced really, we simply switch to another ring-buffer 
| setup ...

It would be also good if the man page added a comment on when a user
would want one ring-buffer setup over the other.

If the main benefit is to have the children profiled when tasks are 
specified, how about changing the option to --inherit (-I) ?

Or for consistency with 'perf record <application>', have --pid profile 
children by default and let users specify --no-inherit with --pid if 
they don't want children profiled.

Sukadev

