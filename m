Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3LBITW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:19:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52249 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:19:20 -0500
X-AuditID: 9c930197-b7caaae000001cef-13-529c42877cea
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 0/6] perf tools: Add perf_evlist errno
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Date: Mon, 02 Dec 2013 17:19:18 +0900
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 29 Nov 2013 12:45:04 +0100")
Message-ID: <87wqjnoebd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 29 Nov 2013 12:45:04 +0100, Jiri Olsa wrote:
> hi,
> Andi reported wrong error message for :S modifier
> on kernel without event ID ioctl support.
>
> The reason was that the ioctl failed, but the error was
> printed like the mmap would:
>
>     $ perf.old record -e '{cycles,cache-misses}:S' ls
>     failed to mmap with 25 (Inappropriate ioctl for device)
>     ls: Terminated

I see same confusing error message..

>
> I experimentally added sort of 'libc errno' interface for
> perf_evlist to be able to get proper error message, like:
>
>     $ perf record -e '{cycles,cache-misses}:S' ls
>     Cannot read event group on this kernel.
>     Please consider kernel update (v3.12+).
>     ls: Terminated
>
> I'm not sure about this approach. Maybe it'd be better be more
> global..? So before throwing this out, sending it as RFC ;-)

I like it. :)  We still need to improve this user-visible error handling.

But what you mean by 'more global'?  I think the evlist APIs are pretty
global alreay.  And we have same error handling in perf_target code too.

But I think it'd be better making it thread-safe even though it's not
needed for now.  The code is growing really fast.. ;-)

Thanks,
Namhyung

