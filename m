Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaEOU1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbaEOU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:27:46 -0400
Date: Thu, 15 May 2014 16:27:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH v2]: fix Haswell precise store data source encoding
Message-ID: <20140515202712.GI50500@redhat.com>
References: <20140515155644.GA3884@quad>
 <20140515195655.GG50500@redhat.com>
 <CABPqkBQtF_ojuDKXAE+WtJ8x7n6QbQOPwFGWJFXSo==oHv3nWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQtF_ojuDKXAE+WtJ8x7n6QbQOPwFGWJFXSo==oHv3nWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:08:51PM +0200, Stephane Eranian wrote:
> On Thu, May 15, 2014 at 9:56 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Thu, May 15, 2014 at 05:56:44PM +0200, Stephane Eranian wrote:
> >>
> >> This patch fixes a bug in  precise_store_data_hsw() whereby
> >> it would set the data source memory level to the wrong value.
> >>
> >> As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
> >> Address Information in PEBS Record), when status bit 0 is set
> >> this is a L1 hit, otherwise this is a L1 miss.
> >>
> >> This patch encodes the memory level according to the specification.
> >>
> >> In V2, we added the filtering on the store events.
> >> Only the following events produce L1 information:
> >>  * MEM_UOPS_RETIRED.STLB_MISS_STORES
> >>  * MEM_UOPS_RETIRED.LOCK_STORES
> >>  * MEM_UOPS_RETIRED.SPLIT_STORES
> >>  * MEM_UOPS_RETIRED.ALL_STORES
> >
> > This worked great on our Haswell-EX box.  I was a little surprised to find
> > out it did until I realized on Ivy Bridge 'mem-store' was a 0x02cd but on
> > Haswell it is now a 0x82d0.  Go generic event types! :-)
> >
> > Looking at the SDM documentation it does say something about
> > 'UOPS_RETIRED.ALL' supporting stores too but can't find that event.  Is
> > that a typo, much like the 0x02 umask for stores on the D0 event is
> > missing from the documentation?  Just wanted to make sure we are not
> > missing one more case.
> >
> But uops_retired.all does not generate the L1 info. That is why it is not
> there in my patch.

Ok.

Cheers,
Don
