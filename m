Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaGCPnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770AbaGCPnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:43:02 -0400
Date: Thu, 3 Jul 2014 17:41:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: probe_event_disable()->synchronize_sched()
Message-ID: <20140703154131.GA5610@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <87pphn45y6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pphn45y6.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Namhyung Kim wrote:
>
> On Tue, 1 Jul 2014 21:31:47 +0200, Oleg Nesterov wrote:
> >
> > And. I am puzzled by probe_event_disable()->synchronize_sched(). Why
> > do we need it? I mean, why we can't use call_rcu() ? The comment says
> > "synchronize with u{,ret}probe_trace_func" but it doesn't explain _why_
> > do we need to sync.
>
> It looks like the code was copied from trace_kprobe.c file.  But IIUC,
> unlike kprobes, uprobe events are always called in a process context.
>
> Also u{,ret}probe_trace_func() call handlers under rcu_read_lock() not
> rcu_read_lock_sched() so I guess the synchronize_sched() can go.

Heh ;) I didn't even notice that "synchronize" and "lock" do not match.
So this should be fixed anyway. But lets discuss other issues first.

Oleg.

