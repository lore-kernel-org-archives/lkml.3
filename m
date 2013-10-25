Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3JYSTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:19:12 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35889 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3JYSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:19:11 -0400
Message-ID: <526AB61B.80505@gmail.com>
Date: Fri, 25 Oct 2013 12:19:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>	<1381468543-25334-7-git-send-email-namhyung@kernel.org>	<CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>	<20131025130417.GB20423@ghostprotocols.net>	<526A8F54.2040601@gmail.com> <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
In-Reply-To: <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 12:12 PM, Frederic Weisbecker wrote:
> Oh I see. It's possible that my massive conversion to use the comm
> accessor got blind at some point and left over a few things. I
> remember that I only lightly tested that new comm infrastructure. I
> mean I tested a lot of "perf report -s foo,bar" combinations for
> performance comparisons but I haven't tested the perf script and all
> the other perf tools.
>
> I'll rebase these patches and test that wider before resending.

specifically, I see stuff like perf forking ls and comm still shows as 
perf even though there is COMM record with the rename to ls. I believe 
the test case was something like:

perf sched record -- ls
perf script

David

