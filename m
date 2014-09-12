Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaILRhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:37:45 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41479 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaILRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:37:43 -0400
Message-ID: <54132F63.1010401@gmail.com>
Date: Fri, 12 Sep 2014 10:37:39 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com> <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/14, 4:48 AM, Pawel Moll wrote:
> This patch adds a PERF_COUNT_SW_MARKER event type, which
> can be requested by user and a PERF_EVENT_IOC_MARKER
> ioctl command which will inject an event of said type into
> the perf buffer. The ioctl can take a zero-terminated
> string argument, similar to tracing_marker in ftrace,
> which will be kept in the "raw" field of the sample.
>
> The main use case for this is synchronisation of
> performance data generated in user space with the perf
> stream coming from the kernel. For example, the marker
> can be inserted by a JIT engine after it generated
> portion of the code, but before the code is executed
> for the first time, allowing the post-processor to
> pick the correct debugging information. Other example
> is a system profiling tool taking data from other
> sources than just perf, which generates a marker
> at the beginning at at the end of the session
> (also possibly periodically during the session) to
> synchronise kernel timestamps with clock values
> obtained in userspace (gtod or raw_monotonic).

Seems really similar to what I proposed in the past:

https://lkml.org/lkml/2011/2/27/159

Which was rejected.

David
