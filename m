Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3JHJhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:37:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59643 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3JHJg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:36:57 -0400
Date: Tue, 8 Oct 2013 11:36:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131008093638.GO3081@twins.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBROM9jZfkU7suD-7=N=M38BCcVgdbgKoe-GE1RhY0puEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:15:30AM +0200, Stephane Eranian wrote:
> Yes, it is but I am trying to see whether or not we could unify that and
> use a single u64 number to uniquely identify each mapping.

No you cannot; two unrelated executables which have distinct mm_ids can
easily mmap() the same shared file.
