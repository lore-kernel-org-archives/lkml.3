Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3GWINh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:13:37 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56120 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3GWINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:13:33 -0400
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 10:13:33 +0200
Message-ID: <CABPqkBSCzjjUU9i8NmscDsH+kuSQ4Cw1atahfwUBRpW-4BuaFw@mail.gmail.com>
Subject: perf: question about event scheduler
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking at ctx_pinned_sched_in() and
ctx_flexible_sched_in() and I am trying to
understand the difference of treatment in
case of errors for the two classes of events
(pinned vs. flexible).

For pinned events, when a group fails to
schedule in, the code goes on to the next
group and therefore walks the entire list
for each scheduler invocation.

For flexible events, when a group fails,
the loop aborts and no subsequent group
is tried.

I am trying to understand the motivation for
this difference here.

If I recall, the abort is here to limit malicious
DoS where a malicious user would provide
an arbitrary long list of events, hogging the kernel.
But in the case of pinned events, this is ignored
because to create such events one needs to be
root in the first place.

Am I getting this right?
