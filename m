Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbaLJPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:21:25 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42291 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbaLJPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <5487D799.5060404@gmail.com>
References: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
	<5487D799.5060404@gmail.com>
Date: Wed, 10 Dec 2014 10:21:23 -0500
Message-ID: <CABPqkBRyraQ_WGDh_nAi4stfymAaj4uAJyYS6ADcC9659LQyOg@mail.gmail.com>
Subject: Re: [BUG] perf mem: perf mem report fails in TUI mode
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 12:18 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/9/14 9:15 PM, Stephane Eranian wrote:
>>
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
>>      $ perf mem -t load rec my_test_program
>>      $ perf mem -t load rep
>>      $ perf mem -t load rep --stdio
>>
>> Debugging with TUI is a pain, so I stopped.
>>
>> I have a patch to improve perf mem a bit but I'd like to get this problem
>> fixed first.
>>
>> Maybe you have a idea of what's going on.
>
>
> I usually avoid the TUI by not installing slang-devel.
>
> But, trying out Linus' current tip (a0e4467726c - post 3.18) this seems to
> work fine:
>     perf mem -t load rec ls
>     perf mem -t load rep
>
What about tip.git?

> But kernel version for the box is 3.16.6-203.fc20.x86_64.
>
> David
