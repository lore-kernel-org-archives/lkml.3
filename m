Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3JHJmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:42:11 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:52894 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3JHJmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131008093638.GO3081@twins.programming.kicks-ass.net>
References: <CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
	<CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
	<20131002190001.GX3081@twins.programming.kicks-ass.net>
	<CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
	<20131002203107.GY3081@twins.programming.kicks-ass.net>
	<CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
	<20131003090347.GB3081@twins.programming.kicks-ass.net>
	<CABPqkBSmYBdBx1vXj3ZJycM311eQPeK6kFxvtm3jtovp-qgm+w@mail.gmail.com>
	<20131008065449.GL3081@twins.programming.kicks-ass.net>
	<CABPqkBROM9jZfkU7suD-7=N=M38BCcVgdbgKoe-GE1RhY0puEg@mail.gmail.com>
	<20131008093638.GO3081@twins.programming.kicks-ass.net>
Date: Tue, 8 Oct 2013 11:42:06 +0200
Message-ID: <CABPqkBQgnqhHwAo9hgg5b-UUV1Zwfs=9TC+-xb3BTP6GqJg8Ag@mail.gmail.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 11:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 08, 2013 at 09:15:30AM +0200, Stephane Eranian wrote:
>> Yes, it is but I am trying to see whether or not we could unify that and
>> use a single u64 number to uniquely identify each mapping.
>
> No you cannot; two unrelated executables which have distinct mm_ids can
> easily mmap() the same shared file.

That seems to indicate the mm_ids is not attached to the right level of VM
data structure. But I am okay with keeping it that way and stashing the mm_id
as a pseudo inode number for the case of non file-backed mappings. If we
say maj=min=ino=gen=0 means no "info", then any other combinations can
be used to identify identical mappings. We use actual min,maj, ino, gen
for file backed, and maj=min=gen=0 + ino = mm_ids for the other cases.
That should work, shouldn't it?
