Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3G3Ivx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:51:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50938 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3G3Ivr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130730083758.GH3008@twins.programming.kicks-ass.net>
References: <20130624084338.GI28407@twins.programming.kicks-ass.net>
	<CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
	<20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
	<CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
	<CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
	<20130708081919.GV23916@twins.programming.kicks-ass.net>
	<CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
	<20130730083758.GH3008@twins.programming.kicks-ass.net>
Date: Tue, 30 Jul 2013 10:51:46 +0200
Message-ID: <CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 30, 2013 at 10:02:01AM +0200, Stephane Eranian wrote:
>> > Ahh. We don't put the useful bits in the mmap event; we'll need to fix
>> > that too then ;-)
>> >
>> > Doing so is going to be a bit of a bother since we use the tail of
>> > PERF_RECORD_MMAP for filenames and thus aren't particularly extensible.
>> >
>> > This would mean doing something like PERF_RECORD_MMAP2 and some means
>> > for userspace to requrest the new events instead of the old one.
>> >
>> Tracking mmaps even for shmat() won't cover the paging cases. When you page a
>> page back in, it most likely gets a different physical page. How would
>> we track that
>> case too using the same approach?
>
> It doesn't matter. Even if a page ends up being a different physical
> page, it will always be the same sb:inode:pgoffset. You should be able
> to always uniquely identify a (shared) page by that triplet.
>
Ok, so you're saying that triplet uniquely identifies a virtual page
regardless of
the physical page it is mapped onto. If the physical page changes because
of paging, we keep the same triplet and therefore we can still detect the false
sharing.

> So if we create a net MMAP record that includes the device (substitute
> for the superblock) and inode information we should be good.

I will try that. I am not familiar with mm, so where do we find the
device? Inside
the vma?
