Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3HBE5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:57:49 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53071 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3HBE5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:57:48 -0400
Message-ID: <51FB3C48.4060500@hitachi.com>
Date: Fri, 02 Aug 2013 13:57:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if
 probe event files are open
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home> <1375322866.5418.46.camel@gandalf.local.home> <1375325414.5418.50.camel@gandalf.local.home> <20130801133455.GB8703@redhat.com>
In-Reply-To: <20130801133455.GB8703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/01 22:34), Oleg Nesterov wrote:
> Just one off-topic note,
> 
>> > @@ -632,7 +635,9 @@ static int release_all_trace_probes(void)
>> >  	/* TODO: Use batch unregistration */
>> >  	while (!list_empty(&probe_list)) {
>> >  		tp = list_entry(probe_list.next, struct trace_probe, list);
>> > -		unregister_trace_probe(tp);
>> > +		ret = unregister_trace_probe(tp);
>> > +		if (ret)
>> > +			goto end;
>> >  		free_trace_probe(tp);
>> >  	}
> This obviously breaks all-or-nothing semantics (I mean, this breaks
> the intent, the current code is buggy).

I see, since we can't lock all operations, we have to change the
semantics. I think it's OK.

> I think we can't avoid this, and I hope this is fine. But then perhaps
> we should simply remove the "list_for_each_entry" check above?

Yes, it should be done. And in that case, I'd like to remove
all removable probes, as much as possible.

BTW, I'd like to replace this "remove all" behavior with
writing "-:*", instead of writing without append flag.

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


