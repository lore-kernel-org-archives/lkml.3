Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3KRUQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:16:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3KRUQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:16:30 -0500
Date: Mon, 18 Nov 2013 21:16:19 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Petr Machata <pmachata@redhat.com>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
Message-ID: <20131118201619.GA26312@host2.jankratochvil.net>
References: <20131118142653.GA27191@gmail.com>
 <20131118174945.GD24375@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118174945.GD24375@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 18:49:45 +0100, Jiri Olsa wrote:
> I think it's an option.. but it'll simpler to try the libdw
> interface first and see if it's good/fast enough..

The elfutils libdw unwinder is being upstreamed these weeks, the x86* unwinder
itself is already upstream now.


> also I recall discussing the speed with libdw developer

My tests with perf using elfutils unwinder were 10x faster than libunwind;
this is by some simple caching of ELF files.  Sure a similar cache could be
implemented also for libunwind.  But the cache is a wrong solution.

The problem is that currently perf loads the ELF files again and again for
every process as the ELF file always gets automatically relocated for the
address where it was loaded.  The right way is to load the ELF file only once
and access always the same copy with process-specific displacement only.

I did not investigate how much feasible it is with libunwind.  For elfutils
there is pmachata/sharing unfinished branch from 2008 to implement that.
I have not checked it more before the unwinder gets fully upstreamed.


Jan
