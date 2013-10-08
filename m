Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3JHTlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:41:36 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56040 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3JHTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:41:33 -0400
Date: Tue, 8 Oct 2013 21:41:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131008194129.GC7315@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <52541556.5060907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52541556.5060907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Stephane:
> 
> On 9/30/13 9:44 AM, Stephane Eranian wrote:
> >I was alerted by people trying to use the PERF_RECORD_MMAP2
> >record to disambiguate virtual address mappings that there is a case
> >where the record does not contain enough information.
> >
> >As you know, the MMAP2 record adds the major, minor, ino number,
> >inode generation numbers to a mapping. But it does that only for
> >file or pseudo -file backed mappings. That covers file mmaps and also
> >SYSV shared memory segments.
> >
> >However there is a another kind of situation that arises in some
> >multi-process benchmarks where a region of memory is cloned
> >using VM_CLONE. As such, the virtual addresses match between
> >the processes but the major, minor, inode, inode generation  fields
> >are all zeroes because there is no inode associated with the mapping.
> >Yet, it is important for the tool to know the mappings between the
> >processes are pointing to the same physical data.
> >
> >We need to cover this case and I am seeking for advice on how to
> >best address this need given that we discarded using the plain physical
> >address for disambiguation.
> 
> 
> If the current MMAP2 is not a complete solution for what you (Google) 
> need, should support be reverted before 3.12 is released? No sense in 
> making this part of the forever API if more work is needed on it.

Instead of a full revert we could just turn off the ABI portion minimally 
and not recognize it for now. Assuming a more complete solution is in the 
works for v3.13.

Thanks,

	Ingo
