Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3JWGP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:15:26 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:40104 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3JWGPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:15:25 -0400
Message-ID: <52676979.7020909@gmail.com>
Date: Wed, 23 Oct 2013 07:15:21 +0100
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 04/14] perf script: Set up output options for in-stream
 attributes
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com> <1382427258-17495-5-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382427258-17495-5-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 8:34 AM, Adrian Hunter wrote:
> +static int process_attr(struct perf_tool *tool, union perf_event *event,
> +			struct perf_evlist **pevlist)
> +{
> +	struct perf_script *scr = container_of(tool, struct perf_script, tool);
> +	struct perf_evlist *evlist;
> +	struct perf_evsel *evsel, *pos;
> +	int err;
> +
> +	err = perf_event__process_attr(tool, event, pevlist);
> +	if (err)
> +		return err;
> +
> +	evlist = *pevlist;
> +	evsel = perf_evlist__last(*pevlist);

This assumes new entries are added to the end of evlist in 
perf_event__process_attr. Would be better to change it to return the 
newly created evsel so you don't need to look it up after adding it.

> +
> +	if (evsel->attr.type >= PERF_TYPE_MAX)
> +		return 0;
> +
> +	list_for_each_entry(pos, &evlist->entries, node) {
> +		if (pos->attr.type == evsel->attr.type && pos != evsel)
> +			return 0;
> +	}

What's the point of this loop?

David
