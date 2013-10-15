Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab3JOPar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:30:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52801 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3JOPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:30:45 -0400
Message-ID: <525D5FA1.7060404@gmail.com>
Date: Tue, 15 Oct 2013 09:30:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com> <1381289214-24885-4-git-send-email-dsahern@gmail.com> <20131009055957.GA7664@gmail.com> <525D4B5F.4090005@gmail.com> <20131015143245.GB9828@ghostprotocols.net> <20131015143819.GM10651@twins.programming.kicks-ass.net> <20131015152747.GA15979@gmail.com>
In-Reply-To: <20131015152747.GA15979@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 9:27 AM, Ingo Molnar wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Tue, Oct 15, 2013 at 11:32:45AM -0300, Arnaldo Carvalho de Melo wrote:
>>
>>> Jiri and PeterZ probaby will have comments here... ;-) :-)
>>
>> The only complication with splice is the vmalloc support; other than
>> that it should be fairly straight fwd.
>
> In the initial version we could skip splice support for vmalloc
> ring-buffer, to keep things simple.
>
> Wanna send a patch for people to try? Looks like there's real interest in
> speeding up perf record as much as possible!

My second -- and more important -- concern about splice has been dropped 
from this path:

"splice is also a system call and it would have to be invoked for each 
mmap each trip through the loop -- just like write() does today -- so it 
does not solve the feedback loop problem. "

Am I missing something on how splice works?

David

