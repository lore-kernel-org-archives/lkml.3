Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbaLJPrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:47:02 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62959 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaLJPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:47:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141210153014.GC6877@krava.brq.redhat.com>
References: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
	<20141210153014.GC6877@krava.brq.redhat.com>
Date: Wed, 10 Dec 2014 10:46:59 -0500
Message-ID: <CABPqkBThUvnJLcddd8Uik_Ssk-a6wojrB6rVCvg-Stzg2Bk+6A@mail.gmail.com>
Subject: Re: [BUG] perf mem: perf mem report fails in TUI mode
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:30 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Dec 09, 2014 at 11:15:13PM -0500, Stephane Eranian wrote:
>> Hi,
>>
>> I was running a couple of tests with perf mem from tip.git and
>> found that perf mem -t load rep was failing only in TUI mode.
>> With --stdio, it works fine. I did a bit of investigation and found
>> out that the TUI mode is failing because some symbol (kernel)
>> is showing up with a huge (negative) size. I don't understand
>> the connection between the TUI vs. tty browser and symbols.
>>
>> To reproduce:
>>     $ perf mem -t load rec my_test_program
>>     $ perf mem -t load rep
>>     $ perf mem -t load rep --stdio
>
> hi,
> I couldn't reproduce any failure on the acme's perf/core
>
What about tip.git?

> since you indicated it's data dependent, could you share
> your perf.data?
>
I can send it to you directly.

> thanks,
> jirka
>
>>
>> Debugging with TUI is a pain, so I stopped.
>>
>> I have a patch to improve perf mem a bit but I'd like to get this problem
>> fixed first.
>>
>> Maybe you have a idea of what's going on.
>>
>> Thanks.
