Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3JCRIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:08:18 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47021 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3JCRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:08:15 -0400
Date: Thu, 3 Oct 2013 14:08:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: report user-friendly error from timechart
Message-ID: <20131003170802.GB2436@ghostprotocols.net>
References: <1380791146-7465-1-git-send-email-artagnon@gmail.com>
 <20131003123820.GA12004@gmail.com>
 <524D7296.3090407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D7296.3090407@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 03, 2013 at 07:35:18AM -0600, David Ahern escreveu:
> On 10/3/13 6:38 AM, Ingo Molnar wrote:
> >
> >* Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> >
> >>+	/* Perform a quick sanity check */
> >>+	if (!is_valid_tracepoint("power:cpu_frequency")) {
> >>+		fprintf(stderr, "Error:\tNo permissions to read $debugfs/tracing/events/power/cpu_frequency\n");
> >>+		fprintf(stderr, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
> >>+		fprintf(stderr, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
> >
> >Is missing permissions the only way how is_valid_tracepoint() can fail?
> >
> >What if debugfs has the right permissions but CONFIG_TRACEPOINTS is
> >disabled in the kernel?
> 
> There are a number of reasons that function can fail. The complete
> solution is to plumb various error numbers and on failure request a
> string for that failure. Take a look at util/target.[ch] as an
> example.
> 
> The comment applies to the perf-trace patch as well, but it gets
> more complicated to handle the error paths from perf_evsel__newtp
> when they dip into the tracepoint code

See the patch I posted, in that case we can use the old errno way, i.e.
do nothing and just look at it in the perf_evsel__newtp/
perf_evlist__add_newtp callers.

And is_valid_tracepoint() is a too big hammer, it traverses the whole
directory looking for a match instead of plain build the path and do an
access, its one of those things I need to ditch at some point. So far I
just try to do a perf_evlist__add_newtp and if it fails, look at errno.

- Arnaldo
