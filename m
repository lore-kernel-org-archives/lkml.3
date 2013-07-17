Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3GQTYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3GQTY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:24:29 -0400
Date: Wed, 17 Jul 2013 21:19:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] tracing: Kill tracing_open/release_generic_file
Message-ID: <20130717191917.GA14137@redhat.com>
References: <20130716185726.GA21200@redhat.com> <1374004295.6458.59.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374004295.6458.59.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16, Steven Rostedt wrote:
>
> On Tue, 2013-07-16 at 20:57 +0200, Oleg Nesterov wrote:
> > trace_array_get() goes away. NOTE! this is actually wrong until we
> > change instance_delete() path to nullify ->i_private.
>
> I think this needs to be done first.

Do you mean "change instance_delete() path to nullify ->i_private" ?

Yes. Well yes and no, afaics, but please ignore. Of course, I won't
send the patches with the holes which I knew about.

Once again, this is just RFC to know your and Masami's opinion. If
you think this can work, I'll try to resend this series with the
additional bits to cover instance_delete() too. _Afaics_ this needs
some temporary uglifications "in between".

So far I am sending 5/4 and 6/4 which changes ftrace_event_format_fops,
in reply to 0/4. The only problem with this file is that f_start/next
imho asks for cleanup which comes as 5/4.

Ignoring instance_delete(), I think this is all we need to make
event/* safe.

So please tell me what do you think.

Oleg.

