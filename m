Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3EPRxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:53:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60573
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab3EPRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:53:01 -0400
Date: Thu, 16 May 2013 19:51:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        Robert Richter <rric@kernel.org>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516175117.GK19669@dyad.programming.kicks-ass.net>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:10:26AM -0400, Josh Boyer wrote:
> Hi All,
> 
> If you boot a KVM guest on an AMD family 15h and specify -cpu host,
> you'll get the following splat:
> 
> [    0.031000] ------------[ cut here ]------------
> [    0.031000] WARNING: at arch/x86/kernel/cpu/perf_event_amd.c:772
> amd_pmu_init+0x18c/0x249()
> [    0.031000] Hardware name: Bochs
> [    0.031000] Odd, counter constraints enabled but no core perfctrs
> detected!
> [    0.031000] Modules linked in:
> 
> [    0.031000] Pid: 1, comm: swapper/0 Not tainted
> 3.9.0-0.rc1.git0.4.fc19.x86_64 #1
> [    0.031000] Call Trace:
> [    0.031000]  [<ffffffff81d10c67>] ? amd_pmu_init+0x18c/0x249
> [    0.031000]  [<ffffffff8105c9a0>] warn_slowpath_common+0x70/0xa0
> [    0.031000]  [<ffffffff81d106b3>] ? check_bugs+0x2d/0x2d
> [    0.031000]  [<ffffffff8105ca1c>] warn_slowpath_fmt+0x4c/0x50
> [    0.031000]  [<ffffffff81d10c67>] amd_pmu_init+0x18c/0x249
> [    0.031000]  [<ffffffff81d106e7>] init_hw_perf_events+0x34/0x428
> [    0.031000]  [<ffffffff81d106b3>] ? check_bugs+0x2d/0x2d
> [    0.031000]  [<ffffffff8100210a>] do_one_initcall+0x10a/0x160
> [    0.031000]  [<ffffffff81d06fa5>] kernel_init_freeable+0xcf/0x1fa
> [    0.031000]  [<ffffffff81629800>] ? rest_init+0x80/0x80
> [    0.031000]  [<ffffffff8162980e>] kernel_init+0xe/0x190
> [    0.031000]  [<ffffffff8164e22c>] ret_from_fork+0x7c/0xb0
> [    0.031000]  [<ffffffff81629800>] ? rest_init+0x80/0x80
> [    0.031000] ---[ end trace a1e57d3cb8668105 ]---
> 
> That seems a bit excessive, and it gets picked up by auto-reporting
> tools like ABRT as a bug.  Can we remove the WARN and just use pr_err or
> something else instead?

Robert put that in, I suppose its because the CPUID crap indicates its got perf
counters but then it doesn't actually have them.

Clearly this is something that should be fixed in your virt thingy instead.
