Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3JIJ7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:59:12 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42128 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3JIJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:59:10 -0400
Date: Wed, 9 Oct 2013 11:59:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131009095906.GB17480@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <52541556.5060907@gmail.com>
 <20131008194129.GC7315@gmail.com>
 <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> > Instead of a full revert we could just turn off the ABI portion 
> > minimally and not recognize it for now. Assuming a more complete 
> > solution is in the works for v3.13.
>
> That's a possibility. They are also pieces in the perf tool itself. We 
> could certainly make the attr->mmap2 bit disappear.
>
> I think it boils down to how can we uniquely identify virtual mapping to 
> the same physical data either via shmat(), files, VM_CLONE. We had all 
> covered but the last case with the ino approach. We don't have a 
> solution for VM_CLONE yet.

PeterZ didn't like exposing the physical RAM address, right?

Peter: could we expose the page frame number instead? (Maybe mix it with a 
random seed through the hash-mixer and expose that.) User-space will thus 
be able to discover whether two pages are shared or not, but not extract 
other information.

The global MM ID thing looked rather ugly as well.

That way we could drop the inode info as well? That feels a bit hacky too.

Thanks,

	Ingo
