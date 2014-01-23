Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaAWO51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbaAWO50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:57:26 -0500
Date: Thu, 23 Jan 2014 15:56:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct hist_entry_iter
Message-ID: <20140123145654.GE1180@krava.brq.redhat.com>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
 <1390436045-16830-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390436045-16830-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:13:45AM +0900, Namhyung Kim wrote:
> There're some duplicate code when adding hist entries.  They are
> different in that some have branch info or mem info but generally do
> same thing.  So introduce new struct hist_entry_iter and add callbacks
> to customize each case in general way.
> 

SNIP

>  
> -	if (sort__mode == SORT_MODE__BRANCH) {
> -		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
> -		if (ret < 0)
> -			pr_debug("problem adding lbr entry, skipping event\n");
> -	} else if (rep->mem_mode == 1) {
> -		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
> -		if (ret < 0)
> -			pr_debug("problem adding mem entry, skipping event\n");
> -	} else {
> -		if (al.map != NULL)
> -			al.map->dso->hit = 1;
> -
> -		ret = report__add_hist_entry(tool, evsel, &al, sample);
> -		if (ret < 0)
> -			pr_debug("problem incrementing symbol period, skipping event\n");
> -	}
> +	if (sort__mode == SORT_MODE__BRANCH)
> +		iter.ops = &hist_iter_branch;
> +	else if (rep->mem_mode == 1)

nit.. mem_mode is bool

jirka
> +
