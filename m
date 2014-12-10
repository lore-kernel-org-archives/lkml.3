Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaLJEPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:15:16 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:48921 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaLJEPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:15:14 -0500
MIME-Version: 1.0
Date: Tue, 9 Dec 2014 23:15:13 -0500
Message-ID: <CABPqkBTLjQPymwDgNKdOshZimKQ0DGWaqm0gC8uFbwPK7vWrsA@mail.gmail.com>
Subject: [BUG] perf mem: perf mem report fails in TUI mode
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was running a couple of tests with perf mem from tip.git and
found that perf mem -t load rep was failing only in TUI mode.
With --stdio, it works fine. I did a bit of investigation and found
out that the TUI mode is failing because some symbol (kernel)
is showing up with a huge (negative) size. I don't understand
the connection between the TUI vs. tty browser and symbols.

To reproduce:
    $ perf mem -t load rec my_test_program
    $ perf mem -t load rep
    $ perf mem -t load rep --stdio

Debugging with TUI is a pain, so I stopped.

I have a patch to improve perf mem a bit but I'd like to get this problem
fixed first.

Maybe you have a idea of what's going on.

Thanks.
