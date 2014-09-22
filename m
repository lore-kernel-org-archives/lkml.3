Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaIVOYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaIVOYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:24:35 -0400
Date: Mon, 22 Sep 2014 16:24:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
Message-ID: <20140922142410.GD18187@krava.brq.redhat.com>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
 <1411229886-24390-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411229886-24390-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 01:18:05AM +0900, Namhyung Kim wrote:

SNIP

> +int perf_callchain_config(const char *var, const char *value)
> +{
> +	if (prefixcmp(var, "call-graph."))
> +		return 0;
> +	var += 11; /* strlen("call-graph.") == 11 */
> +
> +	if (!strcmp(var, "record-mode"))
> +		return parse_callchain_record_opt(value);
> +#ifdef HAVE_DWARF_UNWIND_SUPPORT
> +	if (!strcmp(var, "dump-size")) {
> +		unsigned long size = 0;
> +		int ret;
> +
> +		ret = get_stack_size(value, &size);
> +		callchain_param.dump_size = size;
> +
> +		return ret;
> +	}
> +#endif
> +	if (!strcmp(var, "print-type"))
> +		return parse_callchain_report_opt(value);
> +	if (!strcmp(var, "order"))
> +		return parse_callchain_report_opt(value);
> +	if (!strcmp(var, "threshold"))
> +		return parse_callchain_report_opt(value);
> +	if (!strcmp(var, "print-limit"))
> +		return parse_callchain_report_opt(value);
> +	if (!strcmp(var, "sort-key"))
> +		return parse_callchain_report_opt(value);

so this allows to spcify option like:

[call-graph]
        sort-key = caller,function,1

which might be confusing for someone.. personaly I'm ok with that,
I'm just raising it, because it's not apparent and not sure how
strict we want to be in here ;-)

jirka
