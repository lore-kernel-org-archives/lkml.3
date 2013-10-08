Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3JHHPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:15:32 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:53221 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JHHPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <20131008065449.GL3081@twins.programming.kicks-ass.net>
References: <CABPqkBTeJarBCkVBMGex+g32ak8vzH__x1V0aq4c22dyWJKhGA@mail.gmail.com>
	<CAGXu5jJPtfXd47fG2OR5MW1tZ_MMrv5s5NR9nMvnhnFvcuNWtA@mail.gmail.com>
	<CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
	<CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
	<20131002190001.GX3081@twins.programming.kicks-ass.net>
	<CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
	<20131002203107.GY3081@twins.programming.kicks-ass.net>
	<CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
	<20131003090347.GB3081@twins.programming.kicks-ass.net>
	<CABPqkBSmYBdBx1vXj3ZJycM311eQPeK6kFxvtm3jtovp-qgm+w@mail.gmail.com>
	<20131008065449.GL3081@twins.programming.kicks-ass.net>
Date: Tue, 8 Oct 2013 09:15:30 +0200
Message-ID: <CABPqkBROM9jZfkU7suD-7=N=M38BCcVgdbgKoe-GE1RhY0puEg@mail.gmail.com>
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

On Tue, Oct 8, 2013 at 8:54 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Oct 07, 2013 at 11:04:38PM +0200, Stephane Eranian wrote:
>> Peter,
>>
>> Ok, so I tried this. It does not cover shmat() cases unfortunately.
>> We need that same ++global_mm_id somewhere on that code path.
>> Haven't looked at it in details just yet.
>
> shmat() is a regular shared memory thingy right? So that should be
> covered by the regular inode,dev bits, right?

Yes, it is but I am trying to see whether or not we could unify that and
use a single u64 number to uniquely identify each mapping.
