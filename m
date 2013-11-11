Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3KKUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:45:22 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47894 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3KKUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:45:16 -0500
Message-ID: <528141D8.8090505@gmail.com>
Date: Mon, 11 Nov 2013 13:45:12 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock event
 period test
References: <1384201353-23863-1-git-send-email-acme@infradead.org> <1384201353-23863-11-git-send-email-acme@infradead.org>
In-Reply-To: <1384201353-23863-11-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:

> @@ -58,8 +58,11 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
>   	}
>
>   	if (perf_evlist__open(evlist)) {
> +		const char *knob = "/proc/sys/kernel/perf_event_max_sample_rate";
> +
>   		err = -errno;
> -		pr_debug("Couldn't open evlist: %s\n", strerror(errno));
> +		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
> +			 strerror(errno), knob, (u64)attr.sample_freq);
>   		goto out_delete_maps;
>   	}

Jiri had a patch to drop the sample rate to max. Perhaps re-use that here?


