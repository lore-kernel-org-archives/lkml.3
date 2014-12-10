Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbaLJPq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:46:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbaLJPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:46:26 -0500
Date: Wed, 10 Dec 2014 16:30:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [BUG] perf mem: perf mem report fails in TUI mode
Message-ID: <20141210153014.GC6877@krava.brq.redhat.com>
References: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 11:15:13PM -0500, Stephane Eranian wrote:
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
>     $ perf mem -t load rec my_test_program
>     $ perf mem -t load rep
>     $ perf mem -t load rep --stdio

hi,
I couldn't reproduce any failure on the acme's perf/core

since you indicated it's data dependent, could you share
your perf.data?

thanks,
jirka

> 
> Debugging with TUI is a pain, so I stopped.
> 
> I have a patch to improve perf mem a bit but I'd like to get this problem
> fixed first.
> 
> Maybe you have a idea of what's going on.
> 
> Thanks.
