Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3JCNKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:10:01 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53553 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3JCNJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:09:59 -0400
Date: Thu, 3 Oct 2013 15:09:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf tool: report user-friendly error from timechart
Message-ID: <20131003130955.GA27835@gmail.com>
References: <1380791146-7465-1-git-send-email-artagnon@gmail.com>
 <20131003123820.GA12004@gmail.com>
 <CALkWK0=KpwgTuUanH12dEQSJKmBNvxMJEO9T6FSjNcLNH+h6Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=KpwgTuUanH12dEQSJKmBNvxMJEO9T6FSjNcLNH+h6Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> Ingo Molnar wrote:
> >> +     /* Perform a quick sanity check */
> >> +     if (!is_valid_tracepoint("power:cpu_frequency")) {
> >> +             fprintf(stderr, "Error:\tNo permissions to read $debugfs/tracing/events/power/cpu_frequency\n");
> >> +             fprintf(stderr, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
> >> +             fprintf(stderr, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
> >
> > Is missing permissions the only way how is_valid_tracepoint() can fail?
> >
> > What if debugfs has the right permissions but CONFIG_TRACEPOINTS is
> > disabled in the kernel?
> 
> I'm thinking about all this in terms of files present in debugfs. Will 
> the cpu_frequecy file be present if tracepoints is disabled? (should I 
> quickly check using User-Mode Linux?). If it won't be present, then we 
> can just change the last line to "compiled with debugfs and tracepoints 
> support".

The debug/tracing/events directory won't be present if tracing is 
disabled.

Thanks,

	Ingo
