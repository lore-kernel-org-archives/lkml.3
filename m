Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaCJV5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:57:50 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63112 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaCJV5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:57:49 -0400
MIME-Version: 1.0
Date: Mon, 10 Mar 2014 22:57:48 +0100
Message-ID: <CABPqkBS1A5d-=OBUL6wJA-MAAKK2UTS+_kbYyBN=d-hohSc89Q@mail.gmail.com>
Subject: [BUG] perf annotate: not reporting all events profiles
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I am using tip.git perf and I do the following:

$ perf record -e cycles,instructions foo
$ perf annotate --stdio

(no explicit grouping).

I only see the asm profile for the first event (cycles).
I don't see a way to display the profile for the second
event in the cmdline options.

Yet the code in __cmd_annotate() seems to  try and
display all profiles.

If I use the TUI, it prompts me for the event at the first
screen and I get different asm profiles.

So what is wrong?
