Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3LZOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:11:25 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64528 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3LZOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:11:23 -0500
Message-ID: <52BC390A.2000504@gmail.com>
Date: Thu, 26 Dec 2013 09:11:22 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com> <20131220075759.GA12937@gmail.com> <20131223193757.GA1396@ghostprotocols.net> <52B8D582.9090009@gmail.com> <20131224125342.GC17780@ghostprotocols.net> <20131224133003.GA23382@ghostprotocols.net>
In-Reply-To: <20131224133003.GA23382@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/13, 8:30 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 24, 2013 at 09:53:42AM -0300, Arnaldo Carvalho de Melo escreveu:
>> >The thing to check is perf_evlist__{prepare,start}_workload notification
>> >errors using SIGUSR1, that we need to check for in the caller, and emit
>> >the message, no?
> Something like this:
>
> 1. We tell perf_evlist__prepare_workload that we want a signal if execvp
> fails, it will be a SIGUSR1
>
> 2. We catch that signal in 'stat' and check that we got a signal, only
> problem so far with this signal maze is that we're getting a SIGCHLD
> while I was expecting a SIGUSR1... I.e. the "if (signr != -1) test
> really should be if (signr == SIGUSR1), but I'm getting a SIGCHLD there
> and the elves are tugging me away...

Did the elves release you?

There are all kinds of failure paths with the workload functions. In the 
end I was focusing on perf-stat actually checking the rc on the 
start_workload function. If it fails, then write() failed and something 
happened to the workload process. In that case don't show the counters.

Handling the other error paths with appropriate messages will take 
additional effort - as you are finding. ;-)

David
