Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3EIIkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:40:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60235 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:40:08 -0400
X-AuditID: 9c930197-b7c1fae000001854-aa-518b60e3b833
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, jolsa@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 03/13] perf evlist: add initialzation function for tracepoints
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
	<1368073909-8825-4-git-send-email-dsahern@gmail.com>
Date: Thu, 09 May 2013 17:40:03 +0900
In-Reply-To: <1368073909-8825-4-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Wed, 8 May 2013 22:31:39 -0600")
Message-ID: <87sj1w7di4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed,  8 May 2013 22:31:39 -0600, David Ahern wrote:
> Handles initializations typically done as part of processing the file
> header and HEADER_TRACING_DATA event.
>
[SNIP]
> +int perf_evlist__trace_init(struct perf_evlist *evlist,
> +			    struct perf_session *session)
> +{
> +	struct tracing_data *tdata;
> +	char temp_file[] = "/tmp/perf-XXXXXXXX";
> +	int fd;
> +
> +	fd = mkstemp(temp_file);
> +	if (fd < 0) {
> +		pr_err("mkstemp failed\n");
> +		return -1;
> +	}
> +	unlink(temp_file);
> +
> +	tdata = tracing_data_get(&evlist->entries, fd, false);
> +	if (!tdata)
> +		return -1;
> +
> +	lseek(fd, 0, SEEK_SET);
> +	(void) trace_report(fd, &session->pevent, false);
> +	tracing_data_put(tdata);

I guess you need to close the fd here.

> +
> +	return perf_evlist__prepare_tracepoint_events(evlist, session->pevent);
> +}

Thanks,
Namhyung
