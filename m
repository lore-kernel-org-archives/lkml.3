Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaBFUVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:21:49 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59432 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaBFUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:21:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140206192844.GB27665@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
	<20140206135627.GA26955@infradead.org>
	<CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
	<20140206140705.GB26955@infradead.org>
	<20140206140936.GC26955@infradead.org>
	<CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com>
	<52F3CAE3.7060007@gmail.com>
	<20140206192131.GA27665@infradead.org>
	<20140206192844.GB27665@infradead.org>
Date: Thu, 6 Feb 2014 21:21:44 +0100
Message-ID: <CABPqkBTCW2rzRMzLKpy+B1uWKpReH8T0rogLAQAoqFZpBcZbig@mail.gmail.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 8:28 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Feb 06, 2014 at 05:21:31PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Feb 06, 2014 at 10:48:19AM -0700, David Ahern escreveu:
>> > On 2/6/14, 8:24 AM, Stephane Eranian wrote:
>> > >On Thu, Feb 6, 2014 at 3:09 PM, Arnaldo Carvalho de Melo
>> > >>>>I am using tip.git. Or try 3.11, 3.10.
>
>> > >>But my tests are on top of:
>
>> > >>[acme@ssdandy linux]$ uname -r
>> > >>3.11.4-101.fc18.x86_64
>
>> > >>I thought it was a 3.14ish one, building one to try there...
>
>> > >The kernel must be 3.14-rcX, the tool can be any version.
>
>> > I don't have time to do a git bisect, but I can narrow the window to
>> > 3.13-rc6 and 3.14-rc1. Just happened to update a server yesterday.
>> > perf-top --stdio runs fine on the former and shows the problem on
>> > the latter.
>>
>> Humm,
>>
>>                 /*
>>                  * Either timeout expired or we got an EINTR due to
>>                  * SIGWINCH, refresh screen in both cases.
>>                  */
>>                 switch (poll(&stdin_poll, 1, delay_msecs)) {
>
>> And poll is returning 1:
>
>>    951.068 ( 0.002 ms): poll(ufds: 0x7ff660befbb0, nfds: 1, timeout_msecs: 2000) = 1
>
> We go to the getc(stdin) and it returns EOF :-\
>
Doesn't poll() return 0 if timeout, and 1 if descriptor in this case?
So you're saying you get 1 and getc() returns nothing to read.
Does stdin get closed somehow?
