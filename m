Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3JOMXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab3JOMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:23:16 -0400
Date: Tue, 15 Oct 2013 14:22:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
Message-ID: <20131015122232.GA4942@krava.redhat.com>
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
 <20131015060200.GA3866@gmail.com>
 <8738o3au2g.fsf@sejong.aot.lge.com>
 <20131015072540.GE24584@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015072540.GE24584@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:25:40AM +0200, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > > 3)
> > >
> > > The rec->bytes_at_mmap_start field feels a bit weird. If I read the code 
> > > correctly, in every 'perf record' invocation, rec->bytes_written starts at 
> > > 0 - i.e. we don't have repeat invocations of cmd_record().
> > 
> > rec->bytes_written is updated when it writes to the output file for 
> > synthesizing COMM/MMAP events (this mmap output is not used at that 
> > time).
> 
> Btw., while looking into it, I think advance_output() needlessly 
> obfuscates as well:
> 
> static void advance_output(struct perf_record *rec, size_t size)
> {
>         rec->bytes_written += size;
> }
> 
> that code should just be written open coded.
> 
> So I think all this needs a few good rounds of cleanups, before we can 
> complicate it with a new feature. (the cleanups can be on top of the 
> feature, if they go in at the same time.)

I sent some file code cleanup week ago, I'll rebase
and resend it soon:
http://marc.info/?l=linux-kernel&m=138113836428425&w=2

it's mostly about centralizing the code into file
object.. got no comments so far

jirka
