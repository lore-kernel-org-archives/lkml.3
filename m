Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbaGSAto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:49:44 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42404 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaGSAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:49:43 -0400
Date: Sat, 19 Jul 2014 02:49:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140719004941.GI18735@two.firstfloor.org>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
 <1405123285-23544-2-git-send-email-andi@firstfloor.org>
 <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
 <20140714192451.GC5803@tassilo.jf.intel.com>
 <CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
 <20140714223918.GE5803@tassilo.jf.intel.com>
 <CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:49:43AM +0200, Stephane Eranian wrote:
> On Tue, Jul 15, 2014 at 12:39 AM, Andi Kleen <ak@linux.intel.com> wrote:
> >> I have a problem with this patch.
> >>
> >> It makes: perf mem -t store rec record OP_NA for the store.
> >> It was recording OP_STORE before.
> >>
> >> I think we need to keep LD/ST info. This is useful for analysis
> >> especially if we collect loads/stores simultaneously.
> >>
> >> Was working before for the mem-loads, mem-stores events.
> >
> > Ok. Would it be enough if it only worked for "mem-stores" and not
> > all PEBS events?
> >
> Ok, do that at a minimum.

I fixed it now. However it turned out that "perf mem report"
actually not report mem_op, only mem_lvl.

You may want to fix that separately.

-Andi
