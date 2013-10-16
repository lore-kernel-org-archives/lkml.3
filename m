Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab3JPJaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:30:21 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:45689 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760112Ab3JPJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:30:20 -0400
Date: Wed, 16 Oct 2013 11:30:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] perf: revert PERF_RECORD_MMAP2 support
Message-ID: <20131016093017.GD23440@gmail.com>
References: <20131015161843.GA17653@quad>
 <20131016061502.GB21109@gmail.com>
 <CABPqkBS3WOKRb3i6d7E=vru7WKffp+PGzi8HYDfyTtGABYHiNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS3WOKRb3i6d7E=vru7WKffp+PGzi8HYDfyTtGABYHiNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> > For example by a simple patch that returns -EINVAL (or -ENOSYS) if the 
> > new flag is used - i.e. behaves like the old kernel in that regard - 
> > but leaves the rest in place. (the 'rest' will hopefully be fixed for 
> > v3.13)
>
> That's what I did in my initial revert patch. But it did not include the 
> perf tool revert.

Could the perf tool part have a minimal revert as well?

> I believe in the end, we will still go with the extended MMAP record and 
> not with the physical address (which adds a PERF_SAMPLE_*). So we can 
> leave the attr->mmap2 bit defined and return -EINVAL for now.

Yeah.

> As for the perf tool, we can remove everything and add that later on 
> because the layout of the MMAP2 record may change.

Yes - but can we keep the actual revert patch minimal? I.e. just prevent 
mmap2 records from being generated, or so.

Thanks,

	Ingo
