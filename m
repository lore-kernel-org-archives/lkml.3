Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966516Ab3HHUmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:42:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44704 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966415Ab3HHUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:42:35 -0400
Message-ID: <520402B9.20003@gmail.com>
Date: Thu, 08 Aug 2013 16:42:33 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 01/19] perf: sample after exit loses thread correlation
 - v3
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com> <1375930261-77273-2-git-send-email-dsahern@gmail.com> <20130808145336.GD2851@ghostprotocols.net>
In-Reply-To: <20130808145336.GD2851@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/13 10:53 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 07, 2013 at 10:50:43PM -0400, David Ahern escreveu:
>> Occassionally events (e.g., context-switch, sched tracepoints) are losing
>> the conversion of sample data associated with a thread. For example:
>
> Humm, if we have a tool that traverses the list of threads in a machine
> it will not know, after one of them exits, about it being dead, so I
> think this needs to add a thread->dead, no?
>
> As of now, from what I can remember, the closest to such a tool would
> be:
>
>   perf top --sort pid
>
> But that uses hist_entries that would eventually be decayed as samples
> would cease to be taken at most a few moments after the EXIT event.
>
> But at least for debugging purposes, machine__fprintf() would list dead
> threads as being present, i.e. alive till its pid gets reused.
>
> This is the only, minor, problem that I see with this solution, what do
> you think?

I can add the exit timestamp to the thread struct. non-0 means it has 
died. Ok with that as an indicator?

David

