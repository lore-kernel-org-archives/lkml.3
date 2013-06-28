Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3F1J7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:59:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3F1J7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:59:12 -0400
Date: Fri, 28 Jun 2013 11:58:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130628095828.GG29209@dyad.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <20130624084338.GI28407@twins.programming.kicks-ass.net>
 <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
 <20130625104700.GZ28407@twins.programming.kicks-ass.net>
 <20130625105123.GA13649@gmail.com>
 <20130626103303.GB28407@twins.programming.kicks-ass.net>
 <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:10:50PM +0200, Stephane Eranian wrote:
> After more investigation with the author of the false sharing
> detection tool, I think
> that if the mapping changes, it is okay. The tool can detect this and
> drop the analysis
> at that address. So as long as we can flag the mapping change, we are
> okay. Hopefully,
> it does not occur frequently. If so, then I think there are bigger
> issues to fix on the system
> than false sharing.

But if you index everything using dev:inode:offset it doesn't matter if the
mapping changes; you're invariant to map placement.

And the thing is; we already compute most of that anyway in order to find the
code in DSOs, except there we use filename instead of dev:inode. However if
there were means to open files using dev:inode that might actually be more
reliable than using the filename.
