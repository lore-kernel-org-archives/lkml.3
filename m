Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3JCIzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:55:32 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:42547 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3JCIz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <20131002203107.GY3081@twins.programming.kicks-ass.net>
References: <20131002130143.GF28601@twins.programming.kicks-ass.net>
	<CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
	<20131002133759.GH28601@twins.programming.kicks-ass.net>
	<CAGXu5jLd3yw+RasWgMg_JJPhsfiM+hVhMru4gfkXmAcn7asEdw@mail.gmail.com>
	<CABPqkBTeJarBCkVBMGex+g32ak8vzH__x1V0aq4c22dyWJKhGA@mail.gmail.com>
	<CAGXu5jJPtfXd47fG2OR5MW1tZ_MMrv5s5NR9nMvnhnFvcuNWtA@mail.gmail.com>
	<CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
	<CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
	<20131002190001.GX3081@twins.programming.kicks-ass.net>
	<CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
	<20131002203107.GY3081@twins.programming.kicks-ass.net>
Date: Thu, 3 Oct 2013 10:55:28 +0200
Message-ID: <CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
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

On Wed, Oct 2, 2013 at 10:31 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Oct 02, 2013 at 12:38:54PM -0700, Kees Cook wrote:
>> On Wed, Oct 2, 2013 at 12:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, Oct 02, 2013 at 11:10:15AM -0700, Kees Cook wrote:
>> >> Seems like a simple enough solution. Surely there must be a catch. :)
>> >
>> > I didn't want to add this to the core mm just for perf..
>>
>> It seems like it would be pretty inexpensive. It might also be
>> valuable in other situations. Not that I can think of any at the
>> moment. Additionally, it could likely be hidden by a CONFIG, so that
>> if perf isn't built in, there's no change?
>
> You optimist, you think you can build a kernel without perf? ;-)
>
> Its just that I would hate to add more completely global state to the
> fork() path. The tasklist_lock might be hard to crack, but at least the
> pid-hash could use per bucket locks (it doesn't apparently).
>
> I suppose people don't really care that much about fork() performance;
> which is sad. KSM and THP also add their own global locks :-(

I don't know the MM code but I assume that that vm_mm struct is
allocated dynamically
and maybe you already grabbing a lock while doing this. Could we
leverage that lock
to increment a global generation number?
