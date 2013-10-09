Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab3JIJy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:54:28 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53063 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3JIJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:54:27 -0400
Date: Wed, 9 Oct 2013 11:54:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131009095423.GA17480@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <52541556.5060907@gmail.com>
 <20131008194129.GC7315@gmail.com>
 <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
 <525463B7.3030203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525463B7.3030203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/8/13 1:54 PM, Stephane Eranian wrote:
> >>>If the current MMAP2 is not a complete solution for what you (Google)
> >>>need, should support be reverted before 3.12 is released? No sense in
> >>>making this part of the forever API if more work is needed on it.
> >>
> >>Instead of a full revert we could just turn off the ABI portion minimally
> >>and not recognize it for now. Assuming a more complete solution is in the
> >>works for v3.13.
> >>
> >That's a possibility. They are also pieces in the perf tool itself.
> >We could certainly make the attr->mmap2 bit disappear.
> >
> >I think it boils down to how can we uniquely identify virtual
> >mapping to the same physical data either via shmat(), files, VM_CLONE.
> >We had all covered but the last case with the ino approach. We don't have
> >a solution for VM_CLONE yet.
> >
> 
> I was mainly thinking the 2 parts that generate MMAP2 events: kernel 
> side it's the mmap2 attribute and perf_event_mmap_output; userspace side 
> it's perf_event__synthesize_mmap_event. Certainly the rest of the 
> plumbing can be left in place until the solution is refined as needed.

Could some of you please send a patch ASAP?

Thanks,

	Ingo
