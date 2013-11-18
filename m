Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KROTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:19:52 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55149 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KROTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:19:46 -0500
Message-ID: <528A21FA.1050309@gmail.com>
Date: Mon, 18 Nov 2013 07:19:38 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2 2/3] perf script: Print comm, fork and exit events
 also
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org> <1384752894-10974-2-git-send-email-namhyung@kernel.org> <20131118135700.GB3669@ghostprotocols.net>
In-Reply-To: <20131118135700.GB3669@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/13, 6:57 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 18, 2013 at 02:34:53PM +0900, Namhyung Kim escreveu:
>> If --show-task option is given, also print internal COMM, FORK and
>> EXIT events.  It would be helpful for debugging.
>
> Humm, --show-task-events is clearer albeit long :-\ With shell
> completion shouldn't be an issue tho.
>
> Also, can't we use: perf_event__fprintf_{mmap,comm,task}?

Good point. Those can be used to dump data after perf-script's 
sample_start. From a quick review it looks like perf_event__fprintf can 
be used rather than the lower fprintf_mmap functions.

David
