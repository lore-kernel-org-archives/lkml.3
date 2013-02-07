Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab3BGPXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab3BGPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:23:22 -0500
Date: Thu, 7 Feb 2013 16:22:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] (Was uprobes/perf: pre-filtering)
Message-ID: <20130207152200.GA31073@redhat.com>
References: <20130204190225.GA10840@redhat.com> <20130206181044.GA3752@redhat.com> <20130206194218.GA11998@redhat.com> <87bobwslvr.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bobwslvr.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/07, Namhyung Kim wrote:
>
> On Wed, 6 Feb 2013 20:42:18 +0100, Oleg Nesterov wrote:
> >
> > And why opts->target.system_wide is only set by OPT_BOOLEAN("all-cpus") ?
> > I meant, why I can't do "perf record -e whatever -C0" to create a "global"
> > counter on CPU_0? This doesn't work because __cmd_record() sees !.system_wide
> > and assumes we need perf_event__synthesize_thread_map() which silently fail.
> >
> > So I am sending a single patch to fix the problem which complicated my
> > testing. It is trivial but I am not sure it correct, please review.
>
> Yes, it's not clear how it handles above (-C0) case.  I think it should
> be treated as a system_wide mode like --all-cpus (-a).  So we could set
> ->system_wide to true if -C is given and/or test perf_target__has_cpu()
> for perf_event__synthesize_thread_map() or both.

Yes, thanks... but to be honest I do not understand opts->systemwide as
well.

OK, both 'perf record ... sleep 1' and 'perf record ... -a sleep 1' attach
the counter(s) to the child process, but opts->systemwide differs. In the
latter case run_command() does perf_event__synthesize_threads(). Not sure
this is right.

Btw, I am just curious. You can override the target with "-p" and run the
command, but it seems that it is not possible to create a global counter
and run the command. Not that important, but could be handy.

Oleg.

