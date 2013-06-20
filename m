Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3FTPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:00:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37674 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3FTPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:00:12 -0400
Message-ID: <51C318F6.2030301@gmail.com>
Date: Thu, 20 Jun 2013 09:00:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, eranian@google.com
Subject: Re: [RFC PATCH 4/4] perf: add timehist command
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com> <1370643734-9579-5-git-send-email-dsahern@gmail.com> <20130620104656.GA11256@gmail.com>
In-Reply-To: <20130620104656.GA11256@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/13 4:46 AM, Ingo Molnar wrote:
> Looks very useful!
>
> This is the kind of analysis I thought 'perf sched' might one day end up
> doing.
>
> Do you plan to submit it non-RFC, to be merged?

Yes. Hopefully I can find time to work on it over the next 2 months for 
3.12, 3.13 at the latest.

>
> Your tool could take over the somewhat stale 'perf sched' command as well
> btw., while possibly carrying over some of the perf sched features like
> 'replay'.
>
> 'perf sched record' enough events to support the ones you need:
>
>> >        perf record -e cs -c 1 -ag -- <workload>
> plus:
>
>   'perf sched sum[mary]'       # show the summary
>   'perf sched tree'            # could show the tree.
>   'perf sched hist[ogram]'     # would show the histogram
>
> i.e. feel free to take over 'perf sched' to suit your 'timehist' workflow
> and logic. As the main (and somewhat overworked) author of 'perf sched' I
> have no problem with you taking it over, at all.

It should be part of perf-sched. It is not at the moment for a number of 
(mostly shortcut) reasons. For the next iteration I will look at 
combining it with perf-sched and in the process I will go through the 
existing code for perf-sched.

As an FYI I also have a daemon that provides the functionality in a 
flight recorder mode but with data dumped only when requested. Future 
project to integrate that with perf. ;-)

>
> You could also add a 'perf timehist' alias to the new 'perf sched'
> command, to keep your original (and well established?) naming.

It is well established internally, so a convenience shortcut would 
lessen the pain of moving to newer perf versions when the time comes.

David
