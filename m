Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaGOEFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:05:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:60392 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaGOEFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="561835218"
Date: Mon, 14 Jul 2014 21:05:42 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140715040542.GF5803@tassilo.jf.intel.com>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
 <1405123285-23544-2-git-send-email-andi@firstfloor.org>
 <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
 <20140714192451.GC5803@tassilo.jf.intel.com>
 <CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
 <20140714223918.GE5803@tassilo.jf.intel.com>
 <CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
 <CABPqkBSVRuyOH8bTU4pjLNZMZdHoWFB4y-HJzVWTVowrO2Q+tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSVRuyOH8bTU4pjLNZMZdHoWFB4y-HJzVWTVowrO2Q+tg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:50:27AM +0200, Stephane Eranian wrote:
> On Tue, Jul 15, 2014 at 12:49 AM, Stephane Eranian <eranian@google.com> wrote:
> > On Tue, Jul 15, 2014 at 12:39 AM, Andi Kleen <ak@linux.intel.com> wrote:
> >>> I have a problem with this patch.
> >>>
> >>> It makes: perf mem -t store rec record OP_NA for the store.
> >>> It was recording OP_STORE before.
> >>>
> >>> I think we need to keep LD/ST info. This is useful for analysis
> >>> especially if we collect loads/stores simultaneously.
> >>>
> >>> Was working before for the mem-loads, mem-stores events.
> >>
> >> Ok. Would it be enough if it only worked for "mem-stores" and not
> >> all PEBS events?
> >>
> > Ok, do that at a minimum.
> >
> But if I recall the PEBS stores events were not that many to begin with.

Yes, there are only three store events:

MEM_UOPS_RETIRED.STLB_MISS_STORES
MEM_UOPS_RETIRED.SPLIT_STORES
MEM_UOPS_RETIRED.ALL_STORES

These can be added.

But most others are loads, so if you wanted loads too (besides mem-loads)
it would be nearly a full list.

-Andi
