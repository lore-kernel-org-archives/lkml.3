Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3GROf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:35:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3GROfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:35:55 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=vg5It6jECHwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ew_GO8iv7i0A:10 a=3nbZYyFuAAAA:8 a=cBsI9TqyZyArO2IHqjIA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374158153.6458.235.camel@gandalf.local.home>
Subject: Re: [RFC PATCH V2] tracing/kprobe: Wait for disabling all running
 kprobe handlers
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Thu, 18 Jul 2013 10:35:53 -0400
In-Reply-To: <51E7DA79.4060505@hitachi.com>
References: <20130709082149.GK25631@dyad.programming.kicks-ass.net>
	 <20130709093526.20138.93100.stgit@mhiramat-M0-7522>
	 <20130715182012.GB18505@redhat.com> <51E7DA79.4060505@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 21:07 +0900, Masami Hiramatsu wrote:
> (2013/07/16 3:20), Oleg Nesterov wrote:
> > On 07/09, Masami Hiramatsu wrote:
> >>
> >> Wait for disabling all running kprobe handlers when a kprobe
> >> event is disabled, since the caller, trace_remove_event_call()
> >> supposes that a removing event is disabled completely by
> >> disabling the event.
> >> With this change, ftrace can ensure that there is no running
> >> event handlers after disabling it.
> >>
> >> Changes in V2:
> >>  - Comment (in code) for clarify why we need to wait there.
> >>
> >> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Agreed.
> > 
> > We need this change in any case, whatever we do in trace/trace_events.c
> > and in unregister_trace_probe().
> 
> Steven, I think this patch is still needed anyway even if we are
> discussing file handling bugs, because this fixes another timing bug.

Sure, I'll pull that into my queue now.

-- Steve


