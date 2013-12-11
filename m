Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3LKT2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:28:21 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35946 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:28:18 -0500
Message-ID: <52A8BCCE.9010300@gmail.com>
Date: Wed, 11 Dec 2013 12:28:14 -0700
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
Subject: Re: [PATCH v0 13/71] perf tools: Add machine__get_thread_pid()
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>
> Add a function to get the pid from the tid.
>
> This is needed when using the sched_switch
> tracepoint to follow object code execution.
> sched_switch identifies the thread but, to
> find the process mmaps, we need the process
> pid.

Are you looking up the current or next task? If the former why not use 
sample->pid rather than parsing the sched_switch tracepoint?

David

