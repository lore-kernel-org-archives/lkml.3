Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3JONUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:20:10 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58714 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab3JONUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:20:08 -0400
Date: Tue, 15 Oct 2013 15:20:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
Message-ID: <20131015132003.GF2402@gmail.com>
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
 <20131015060200.GA3866@gmail.com>
 <8738o3au2g.fsf@sejong.aot.lge.com>
 <20131015072540.GE24584@gmail.com>
 <20131015122232.GA4942@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015122232.GA4942@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Oct 15, 2013 at 09:25:40AM +0200, Ingo Molnar wrote:
> > 
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> > 
> > > > 3)
> > > >
> > > > The rec->bytes_at_mmap_start field feels a bit weird. If I read the code 
> > > > correctly, in every 'perf record' invocation, rec->bytes_written starts at 
> > > > 0 - i.e. we don't have repeat invocations of cmd_record().
> > > 
> > > rec->bytes_written is updated when it writes to the output file for 
> > > synthesizing COMM/MMAP events (this mmap output is not used at that 
> > > time).
> > 
> > Btw., while looking into it, I think advance_output() needlessly 
> > obfuscates as well:
> > 
> > static void advance_output(struct perf_record *rec, size_t size)
> > {
> >         rec->bytes_written += size;
> > }
> > 
> > that code should just be written open coded.
> > 
> > So I think all this needs a few good rounds of cleanups, before we can 
> > complicate it with a new feature. (the cleanups can be on top of the 
> > feature, if they go in at the same time.)
> 
> I sent some file code cleanup week ago, I'll rebase and resend it soon:
>
> http://marc.info/?l=linux-kernel&m=138113836428425&w=2

Nice!

> it's mostly about centralizing the code into file object.. got no 
> comments so far

Too much development going on I suspect :-)

Thanks,

	Ingo
