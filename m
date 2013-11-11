Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3KKMHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:07:06 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38959 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3KKMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:07:01 -0500
Date: Mon, 11 Nov 2013 13:06:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131111120655.GC21291@gmail.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
 <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
 <20131105094220.GA1071@krava.brq.redhat.com>
 <5278EE0A.1080108@intel.com>
 <20131105133024.GE1071@krava.brq.redhat.com>
 <20131105142545.GD22912@ghostprotocols.net>
 <20131105173152.GB7329@ghostprotocols.net>
 <20131108084001.GG19203@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108084001.GG19203@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 05, 2013 at 02:31:52PM -0300, Arnaldo Carvalho de Melo wrote:
> > PeterZ,
> > 
> > 	Can I have your Acked-by for this one? I guess now the goal is
> > achieved, no?
> 
> So this option allows -t/-p/-u to create one buffer per cpu and attach
> all the various thread/process/user tasks' their counters to that one
> buffer?
> 
> As opposed to the current state where each such counter would have its
> own buffer.
> 
> If this is what the patch does, then yes, although I would prefer a
> slightly clearer Changelog.
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Is there any reason why we wouldn't want to make this the default 
behavior?

That way we could also lose the somewhat suboptimal 'force' naming: 
there's nothing forced really, we simply switch to another ring-buffer 
setup ...

Thanks,

	Ingo
