Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3GCR7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3GCR7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:59:09 -0400
Date: Wed, 3 Jul 2013 19:54:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130703175420.GA25668@redhat.com>
References: <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com> <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703172029.GA14309@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Oleg Nesterov wrote:
>
> IOW. So far _I think_ we just need the additional changes in
> trace_remove_event_call() if it succeeds (with the patch I sent)
> to prevent the races like above, but I didn't even try to think
> about this problem.

And I guess greatly underestimated the problem(s). When I look at
this code now, it seems that, say, event_enable_write() will use
the already freed ftrace_event_file in this case.

Still I think this is another (although closely related) problem.

> Or I missed your point completely?

Yes?

Oleg.

