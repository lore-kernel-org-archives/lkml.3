Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3JCMol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:44:41 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42381 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3JCMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <20131003123820.GA12004@gmail.com>
References: <1380791146-7465-1-git-send-email-artagnon@gmail.com> <20131003123820.GA12004@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 3 Oct 2013 18:13:59 +0530
Message-ID: <CALkWK0=KpwgTuUanH12dEQSJKmBNvxMJEO9T6FSjNcLNH+h6Cw@mail.gmail.com>
Subject: Re: [PATCH] perf tool: report user-friendly error from timechart
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +     /* Perform a quick sanity check */
>> +     if (!is_valid_tracepoint("power:cpu_frequency")) {
>> +             fprintf(stderr, "Error:\tNo permissions to read $debugfs/tracing/events/power/cpu_frequency\n");
>> +             fprintf(stderr, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
>> +             fprintf(stderr, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
>
> Is missing permissions the only way how is_valid_tracepoint() can fail?
>
> What if debugfs has the right permissions but CONFIG_TRACEPOINTS is
> disabled in the kernel?

I'm thinking about all this in terms of files present in debugfs. Will
the cpu_frequecy file be present if tracepoints is disabled? (should I
quickly check using User-Mode Linux?). If it won't be present, then we
can just change the last line to "compiled with debugfs and
tracepoints support".
