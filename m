Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaJ1MMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:12:09 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49660 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaJ1MMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:12:07 -0400
Date: Tue, 28 Oct 2014 12:11:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: vfp: Fix VFPv3 hwcap detection on CPUID
 based cpus
Message-ID: <20141028121154.GA12136@arm.com>
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
 <1413294539-22069-3-git-send-email-sboyd@codeaurora.org>
 <20141027103118.GA8768@arm.com>
 <544EA212.7030401@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544EA212.7030401@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 07:50:42PM +0000, Stephen Boyd wrote:
> On 10/27/2014 03:31 AM, Will Deacon wrote:
> > On Tue, Oct 14, 2014 at 02:48:58PM +0100, Stephen Boyd wrote:
> >> If the CPU is using CPUID scheme, use the MVFR registers to
> >> determine what version of VFP is supported. We already do this
> >> for VFPv4, so do something similar for VFPv3 and look for single
> >> or double precision support in MVFR0. Otherwise fall back to
> >> using FPSID to detect VFP suppport on non-CPUID scheme CPUs. We
> >> know that VFPv3 is only present in CPUs that have support for the
> >> CPUID scheme so this should be equivalent.
> > This looks correct to me, but it raises a bigger question about the
> > suitability of hwcaps for describing features of the instruction set.
> 
> Great. Can I get your reviewed-by on this patch please?

Sure. There's a spelling mistake ("arhitecture") which you should fix,
but the code looks ok.

> > With the extended CPUID scheme, there are a whole bunch of different
> > instruction set features that are reported and bundling arbitrary subsets of
> > them into hwcaps such as `VFPv4' doesn't feel like the right thing to do in
> > the long run. It also doesn't seem to match where the architecture is going.
> >
> > Perhaps it would be better to consider exposing the ID registers to
> > userspace in some manner? This could be done either via an undef handler, or
> > using the vdso. We would add a (final) hwcap advertising this cpuid support.
> > For big/little systems, the kernel would need to expose a suitable subset of
> > the features (we already have the sanity checking code from Rutland).
> >
> > I'd certainly like to explore that route for arm64, before we start adding a
> > bunch of fine-grained capabilities.
> 
> I have an RFC for the undef handler written up, except for the
> big/little thing. Let me post it. Is there anyone from the userspace
> side that can be on Cc?

Off the top of my head:

  Mans Rullgard (already replied to this thread)
  Peter Maydell <peter.maydell@linaro.org> [QEMU]
  Jacob Bramley <jacob.bramley@arm.com> [JITs]
  Kyrylo Tkachov <kyrylo.tkachov@arm.com> [GCC]

(CC Rutland for the big/little bits too)

Will
