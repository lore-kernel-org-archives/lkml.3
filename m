Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3J0OjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 10:39:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab3J0OjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 10:39:19 -0400
Date: Sun, 27 Oct 2013 14:39:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] alpha: perf: fix out-of-bounds array access triggered
 from raw event
Message-ID: <20131027143903.GA17732@mudshark.cambridge.arm.com>
References: <1378807092-28674-1-git-send-email-will.deacon@arm.com>
 <20130910101944.GA13664@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910101944.GA13664@omega>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Tue, Sep 10, 2013 at 11:19:44AM +0100, Michael Cree wrote:
> On Tue, Sep 10, 2013 at 10:58:12AM +0100, Will Deacon wrote:
> > Vince's perf fuzzer uncovered the following issue on Alpha:
> > 
> > Unable to handle kernel paging request at virtual address fffffbfe4e46a0e8
> > CPU 0 perf_fuzzer(1278): Oops 0
> > pc = [<fffffc000031fbc0>]  ra = [<fffffc000031ff54>]  ps = 0007    Not tainted
> > pc is at alpha_perf_event_set_period+0x60/0xf0
> > ra is at alpha_pmu_enable+0x1a4/0x1c0
> > v0 = 0000000000000000  t0 = 00000000000fffff  t1 = fffffc007b3f5800
> > t2 = fffffbff275faa94  t3 = ffffffffc9b9bd89  t4 = fffffbfe4e46a098
> > t5 = 0000000000000020  t6 = fffffbfe4e46a0b8  t7 = fffffc007f4c8000
> > s0 = 0000000000000000  s1 = fffffc0001b0c018  s2 = fffffc0001b0c020
> > s3 = fffffc007b3f5800  s4 = 0000000000000001  s5 = ffffffffc9b9bd85
> > s6 = 0000000000000001
> > a0 = 0000000000000006  a1 = fffffc007b3f5908  a2 = fffffbfe4e46a098
> > a3 = 00000005000108c0  a4 = 0000000000000000  a5 = 0000000000000000
> > t8 = 0000000000000001  t9 = 0000000000000001  t10= 0000000027829f6f
> > t11= 0000000000000020  pv = fffffc000031fb60  at = fffffc0000950900
> > gp = fffffc0000940900  sp = fffffc007f4cbca8

[...]

> > This patch adds a new callback to alpha_pmu_t for validating the raw
> > event encoding with the Linux event types for the PMU, preventing the
> > out-of-bounds array access.
> > 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Michael Cree <mcree@orcon.net.nz>
> > Cc: Matt Turner <mattst88@gmail.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Acked-by: Michael Cree <mcree@orcon.net.nz>

I just remembered about this patch whilst cleaning up some old git branches.
Please could you include it in the Alpha tree with a CC stable? Without it,
it's trivial to panic a perf-enabled Alpha kernel from userspace.

Cheers,

Will
