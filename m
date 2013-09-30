Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3I3NuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:50:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62538 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3I3NuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:50:03 -0400
Message-ID: <52498187.10900@gmail.com>
Date: Mon, 30 Sep 2013 07:49:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data
 file
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/13 2:19 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> perf-record updates the header in the perf.data file at termination.
> Without this update perf-report (and other processing built-ins) it
> caused an infinite loop when perf report (or something like) called.
>
> This is because the algorithm in __perf_session__process_events()
> depends on the data_size which is read from file header.  Use file
> size directly instead in this case to do the best-effort processing.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

worked ok for me. Sonny can you verify?

David

