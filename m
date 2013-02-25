Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3BYJ7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:59:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab3BYJ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:58:59 -0500
Date: Mon, 25 Feb 2013 10:58:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf/tools: Fix "perf record -C... workload"
 behaviour
Message-ID: <20130225095839.GC1041@krava.brq.redhat.com>
References: <20130204190225.GA10840@redhat.com>
 <20130206181044.GA3752@redhat.com>
 <20130206194218.GA11998@redhat.com>
 <20130206194258.GB11998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206194258.GB11998@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 08:42:58PM +0100, Oleg Nesterov wrote:
> Test-case:
> 
> 	# perf record -e probe_libc:syscall -C0 true
> 	true: Terminated
> 
> The child process is killed by perf_record__sig_exit(). This is because
> perf_evlist__prepare_workload() doesn't initialize threads->map[] and
> then perf_event__synthesize_mmap_events() (silently!) fails. This patch

hi,
sorry for late reply..

I think the reason it fails is that it actually got inside
perf_event__synthesize_mmap_events while there's cpu list
specified.

I sent possible fix:
http://marc.info/?l=linux-kernel&m=136178604718144&w=2


> seems to fix the problem, but perhaps we should also move
> 'pr_err("Couldn't run the workload!\n")' down to 'out_delete_session:',

I'll check ;-)

thanks,
jirka
