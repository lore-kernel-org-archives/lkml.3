Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3JJE4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:56:40 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:65263 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JJE4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:56:38 -0400
Date: Thu, 10 Oct 2013 06:56:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, dsahern@gmail.com,
        ak@linux.intel.com, jolsa@redhat.com, hughd@google.com,
        keescook@chromium.org, akpm@linux-foundation.org
Subject: Re: [PATCH] perf: disable mmap2 support
Message-ID: <20131010045635.GC23267@gmail.com>
References: <20131009161743.GA3022@quad>
 <20131009193322.GA3794@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009193322.GA3794@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Wed, Oct 09, 2013 at 06:17:43PM +0200, Stephane Eranian escreveu:

> > This patch disables the mmap2 record format support for now. The 
> > support needs a bit more work to cover VM_CLONE cases.
> > 
> > The patch leaves attr->mmap2 defined, but returns an error if it is 
> > set. That ensures no PERF_RECORD_MMAP2 record can be generated. Yet it 
> > minimizes the reverts in the perf tool.
> 
> Would be interesting to have a simple new tool that would detect all the 
> mmaps that are shared in a given perf.data file, using the 
> PERF_RECORD_MMAP2 information, and that tool should come together with 
> the reworked kernel ABI, showing how it is used.

Indeed. Let's make that a requirement for the next round of mmap2 patches. 

Issues like this is really why I hate not getting a fully functional 
usecase together with a new ABI - it's _so_ easy to come up with something 
subtly (or not so subtly) incomplete.

> A 'perf test' entry, based on the test programs you guys are using to 
> test this functionality would be even better, showing that all cases 
> you've been striving to cover are in fact covered by the new ABI.

That too, in addition to an actual tool that people can use.

Thanks,

	Ingo
