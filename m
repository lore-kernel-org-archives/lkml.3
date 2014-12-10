Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLJFSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 00:18:21 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41079 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaLJFSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 00:18:20 -0500
Message-ID: <5487D799.5060404@gmail.com>
Date: Tue, 09 Dec 2014 22:18:17 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [BUG] perf mem: perf mem report fails in TUI mode
References: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
In-Reply-To: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/14 9:15 PM, Stephane Eranian wrote:
> Hi,
>
> I was running a couple of tests with perf mem from tip.git and
> found that perf mem -t load rep was failing only in TUI mode.
> With --stdio, it works fine. I did a bit of investigation and found
> out that the TUI mode is failing because some symbol (kernel)
> is showing up with a huge (negative) size. I don't understand
> the connection between the TUI vs. tty browser and symbols.
>
> To reproduce:
>      $ perf mem -t load rec my_test_program
>      $ perf mem -t load rep
>      $ perf mem -t load rep --stdio
>
> Debugging with TUI is a pain, so I stopped.
>
> I have a patch to improve perf mem a bit but I'd like to get this problem
> fixed first.
>
> Maybe you have a idea of what's going on.

I usually avoid the TUI by not installing slang-devel.

But, trying out Linus' current tip (a0e4467726c - post 3.18) this seems 
to work fine:
     perf mem -t load rec ls
     perf mem -t load rep

But kernel version for the box is 3.16.6-203.fc20.x86_64.

David
