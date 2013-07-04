Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab3GDATl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:19:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570Ab3GDATi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:19:38 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=VwQbUJbxAAAA:8 a=DgIrJZqeKAH2_VcHJvIA:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372897175.22688.135.camel@gandalf.local.home>
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Jul 2013 20:19:35 -0400
In-Reply-To: <20130703221847.GA15566@redhat.com>
References: <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
	 <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>
	 <20130703175420.GA25668@redhat.com>
	 <1372874547.22688.111.camel@gandalf.local.home>
	 <20130703191748.GA2884@redhat.com>
	 <1372883643.22688.118.camel@gandalf.local.home>
	 <20130703221847.GA15566@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 00:18 +0200, Oleg Nesterov wrote:
> On 07/03, Steven Rostedt wrote:
> >
> > No, I would avoid any changes to the debugfs infrastructure.
> 
> YEs, agreed.
> 
> > OK, what about the below patch, followed by an updated version of your
> > patch. I'll send that as a reply to this one.
> 
> Steven, you do understand that I can't review the changes in this area.

I have more faith in you than you do ;-)

> 
> But at first glance, _I think_ this should work. And this is much simpler,
> ->open() blocks trace_remove_event_call() (you added TRACE_EVENT_FL_REF_MASK
> check into the next patch).

Yep.

> 
> Which tree this patch is based on? I have pulled linux-trace.git#for-next
> and I do not see tracing_open_generic_file/etc in trace_events.c.

Ug! Thanks! I posted my [for-next] series but never pushed it to my git
tree. I just pushed it now. I'm glad you told me this because I was
under the assumption that the code was already in my kernel.org repo,
and I would have pushed to Linus thinking it was already in linux-next
and would have been embarrassed if something went wrong.

> 
> I do not understand what protects call->flags, I guess there is another
> lock which I do not see in my tree?

Those flags should only be set under the event_mutex lock. But I see I
didn't do that :-)   Yeah, I need to add locks for that.

See, you can review my patch and provide valuable feedback!

-- Steve


