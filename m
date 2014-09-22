Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaIVPTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:19:21 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63905 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaIVPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:19:20 -0400
Subject: Re: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20140922142410.GD18187@krava.brq.redhat.com>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
	 <1411229886-24390-5-git-send-email-namhyung@kernel.org>
	 <20140922142410.GD18187@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Sep 2014 00:19:13 +0900
Message-ID: <1411399153.1665.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-22 (월), 16:24 +0200, Jiri Olsa:
> On Sun, Sep 21, 2014 at 01:18:05AM +0900, Namhyung Kim wrote:
> 
> SNIP
> 
> > +int perf_callchain_config(const char *var, const char *value)
> > +{
> > +	if (prefixcmp(var, "call-graph."))
> > +		return 0;
> > +	var += 11; /* strlen("call-graph.") == 11 */
> > +
> > +	if (!strcmp(var, "record-mode"))
> > +		return parse_callchain_record_opt(value);
> > +#ifdef HAVE_DWARF_UNWIND_SUPPORT
> > +	if (!strcmp(var, "dump-size")) {
> > +		unsigned long size = 0;
> > +		int ret;
> > +
> > +		ret = get_stack_size(value, &size);
> > +		callchain_param.dump_size = size;
> > +
> > +		return ret;
> > +	}
> > +#endif
> > +	if (!strcmp(var, "print-type"))
> > +		return parse_callchain_report_opt(value);
> > +	if (!strcmp(var, "order"))
> > +		return parse_callchain_report_opt(value);
> > +	if (!strcmp(var, "threshold"))
> > +		return parse_callchain_report_opt(value);
> > +	if (!strcmp(var, "print-limit"))
> > +		return parse_callchain_report_opt(value);
> > +	if (!strcmp(var, "sort-key"))
> > +		return parse_callchain_report_opt(value);
> 
> so this allows to spcify option like:
> 
> [call-graph]
>         sort-key = caller,function,1
> 
> which might be confusing for someone.. personaly I'm ok with that,
> I'm just raising it, because it's not apparent and not sure how
> strict we want to be in here ;-)

Right, I just reused parse_callchain_{record,report}_opt() functions to
simplify the code.

Hmm.. now I rethink that at least threshold and print-limit will be
treated differently as parse_callchain_report_opt() implies an order of
them.  Will change in the next version.

Thanks,
Namhyung



