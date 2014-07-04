Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbaGDTj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbaGDTj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:39:58 -0400
Date: Fri, 4 Jul 2014 21:38:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: __trace_remove_event_dirs() leaks file->filter ? (Was:
	probe_event_disable()->synchronize_sched())
Message-ID: <20140704193831.GA27490@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com> <20140703162211.GB5610@redhat.com> <20140703170109.GA10208@redhat.com> <53B639DE.8030102@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B639DE.8030102@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, Masami Hiramatsu wrote:
>
> (2014/07/04 2:01), Oleg Nesterov wrote:
> > On 07/03, Oleg Nesterov wrote:
> >>
> >> Hmm. Off-topic, but it seems that instance_rmdir() leaks the memory? Say,
> >> file->filter?
> >
> > Perhaps I am totally confused, but don't we need something like the patch
> > below? I'll try to recheck later...
> >
> > Better yet, we can probably move destroy_preds() from event_remove() to
> > remove_event_file_dir()... not sure, need to recheck.
>
> Ah, yes, it seems event_remove releases preds, and remove_event_file_dir()
> called from event_trace_del_tracer() doesn't release it.
>
> BTW, with following patch, we'd better remove destroy_preds() from
> event_remove() and add destroy_call_preds() at the very last of the
> function.

Yes, please see "Better yet" above. And probably we can simply remove
destroy_preds() after that.

But I still need to reccheck, didn't have time today. And you know what?
call->filter logic looks broken too ;)

Oleg.

