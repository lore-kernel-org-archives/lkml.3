Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3GBWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:53:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3GBWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:53:52 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=VwQbUJbxAAAA:8 a=sXYDtujRaDtWQ_bHetcA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372805630.22688.70.camel@gandalf.local.home>
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
Date: Tue, 02 Jul 2013 18:53:50 -0400
In-Reply-To: <20130702222359.GA27629@redhat.com>
References: <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com>
	 <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com>
	 <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 00:23 +0200, Oleg Nesterov wrote:

>  /* Remove an event_call */
> -void trace_remove_event_call(struct ftrace_event_call *call)
> +int trace_remove_event_call(struct ftrace_event_call *call)
>  {
> +	int err;
> +
>  	mutex_lock(&event_mutex);
>  	down_write(&trace_event_sem);

Oh, BTW, can you rebase this on top of my for-next branch. That's what
I'll be pushing off to Linus, and this will conflict with those changes.

-- Steve

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git


> -	__trace_remove_event_call(call);
> +	err = event_can_remove(call);
> +	if (!err)
> +		__trace_remove_event_call(call);
>  	up_write(&trace_event_sem);
>  	mutex_unlock(&event_mutex);
> +
> +	return err;
>  }
>  
>  #define for_each_event(event, start, end)			\


