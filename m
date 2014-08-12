Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaHLEog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 00:44:36 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57459 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaHLEof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 00:44:35 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 06:44:34 +0200
Message-ID: <CABPqkBRqqz6dEYuFvJL4M+p2h-m0P09h4fDVq6-f8fZJq6NSCA@mail.gmail.com>
Subject: [BUG] perf top: -z option does not work
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


My understanding is that the -z option is used to only print a profile
since the last refresh. So if I have a refresh of 5s, then it prints the profile
based on the samples accumulated over the last 5 seconds.

The Z mode used to be available interactively. Nowadays, it seems only
avail from the cmdline. But it does not work.

I run a simple test.
$ sudo perf top -z

Then for 5s I run a cycle-burning noploop program.
It shows up at the top. But when it terminates, the program  still stays
at the top of the profile for a long time. This is not what I'd expect.
The noploop line should disappear in the next couple of refreshes after
the program has terminated.

I am using tip.git and seeing the problem. But it seems, it's been there for a
long time.

Any idea what's wrong?

Thanks.
