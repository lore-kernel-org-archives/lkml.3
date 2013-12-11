Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LKThY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:37:24 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56199 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LKThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:37:21 -0500
Message-ID: <52A8BEEB.1040203@gmail.com>
Date: Wed, 11 Dec 2013 12:37:15 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 27/71] perf evlist: Add 'system_wide' option
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-28-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1386765443-26966-28-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>
> Add an option to cause a selected event
> to be opened always without a pid when
> configured by perf_evsel__config().
>
> This is needed when using the sched_switch
> tracepoint to follow object code execution.
> sched_switch occurs before the task
> switch and so it cannot record it in a
> context limited to that task.  Note
> that also means that sched_switch is
> useless when capturing data per-thread,
> as is the 'context-switches' software
> event for the same reason.

This seems like a tailored solution for what is really a generic 
problem: you need events to have different attributes -- a mix of system 
wide, task based, with or without callchains and other sample options.

David
