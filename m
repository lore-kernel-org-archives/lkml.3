Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3LCQUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:20:30 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54586 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3LCQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:20:28 -0500
Message-ID: <529E04C7.5090804@gmail.com>
Date: Tue, 03 Dec 2013 09:20:23 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/3] perf tools: Record sampling time for each entry
References: <1386061229-19514-1-git-send-email-namhyung@kernel.org> <1386061229-19514-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1386061229-19514-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/13, 2:00 AM, Namhyung Kim wrote:
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 20a7c653b74b..ac65fc67972c 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -69,6 +69,7 @@ struct perf_evsel {
>   	struct hists		hists;
>   	u64			first_timestamp;
>   	u64			last_timestamp;
> +	u64			*prev_timestamps;


Why plural and why dynamically allocated? The allocation only does a 
single u64, not an array.

David
