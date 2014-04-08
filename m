Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbaDHSRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:17:10 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33876 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbaDHSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:17:08 -0400
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 11:17:07 -0700
Message-ID: <CABPqkBQeAqRUW8LLMsHhHBR8gJcE4VPZa++ji8i=RKUCd2jSvQ@mail.gmail.com>
Subject: [BUG] perf record: does not propagate command error code
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a discrepancy in the way perf stat and perf record propagate
command error code back when they launch a process:

$ perf record -e cycles false && echo "yes" || echo "no"
yes

That's wrong!

But perf stat:

$ perf stat -e cycles false && echo "yes" || echo "no"
no

That's correct!

You want the error to be propagated back because it helps
catch errors in monitoring scripts.

I looked at the perf record code handling the error from the child.
It is complicated and uses atexit() to cleanup the child. It is hard
to get the child exit status back. I wonder why this was handled
that way.

Anybody has a fix for this?

Thanks
