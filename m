Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab3GZQ2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:28:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1868 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab3GZQ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:28:15 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51F2A08B.2090207@broadcom.com>
Date: Fri, 26 Jul 2013 18:15:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Z Lam" <azl@google.com>,
        "Vaibhav Nagarnaik" <vnagarnaik@google.com>,
        "David Sharp" <dhsharp@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 9/9] tracing: Remove locking trace_types_lock from
 tracing_reset_all_online_cpus()
References: <20130726130327.911599518@goodmis.org>
 <20130726130513.428993451@goodmis.org>
In-Reply-To: <20130726130513.428993451@goodmis.org>
X-WSS-ID: 7DEC7D2431W56242533-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 03:03 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)"<rostedt@goodmis.org>
>
> Commit a82274151af "tracing: Protect ftrace_trace_arrays list in trace_events.c"
> added taking the trace_types_lock mutex in trace_events.c as there were
> several locations that needed it for protection. Unfortunately, it also
> encapsulated a call to tracing_reset_all_online_cpus() which also takes
> the trace_types_lock, causing a deadlock.
>
> This happens when a module has tracepoints and has been traced. When the
> module is removed, the trace events module notifier will grab the
> trace_types_lock, do a bunch of clean ups, and also clears the buffer
> by calling tracing_reset_all_online_cpus. This doesn't happen often
> which explains why it wasn't caught right away.
>
> Commit a82274151af was marked for stable, which means this must be
> sent to stable too.
>
> Link:http://lkml.kernel.org/r/51EEC646.7070306@broadcom.com
>
> Reported-by: Arend van *Spril*<arend@broadcom.com>

Nasty dutch names, huh. If we ever meet on a summit you may try to 
pronounce it :-) Way easier than Finnish.

Regards,
Arend

> Tested-by: Arend van *Spriel*<arend@broadcom.com>
> Cc: Alexander Z Lam<azl@google.com>
> Cc: Vaibhav Nagarnaik<vnagarnaik@google.com>
> Cc: David Sharp<dhsharp@google.com>
> Cc:stable@vger.kernel.org  # 3.10
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>   kernel/trace/trace.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)


