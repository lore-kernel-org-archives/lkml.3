Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbbAGOGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:06:20 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42941 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbAGOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:06:18 -0500
Date: Wed, 7 Jan 2015 22:06:12 +0800
From: Leo Yan <leo.yan@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Xiaolong Ye <yexl@marvell.com>
Subject: Re: [PATCH] arm64: mm: support instruction SETEND
Message-ID: <20150107140612.GA5994@leoy.com>
References: <1420609930-1689-1-git-send-email-leo.yan@linaro.org>
 <54AD061A.6090602@arm.com>
 <20150107105824.GA13620@leoy.com>
 <20150107111148.GH7485@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107111148.GH7485@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 11:11:48AM +0000, Will Deacon wrote:
> On Wed, Jan 07, 2015 at 10:58:24AM +0000, Leo Yan wrote:
> > On Wed, Jan 07, 2015 at 10:10:34AM +0000, Suzuki K. Poulose wrote:
> > > On 07/01/15 05:52, Leo Yan wrote:
> > > >Currently kernel has set the bit SCTLR_EL1.SED, so the SETEND
> > > >instruction will be treated as UNALLOCATED; this error can be
> > > >reproduced when ARMv8 cpu runs with EL1/aarch64 and EL0/aarch32
> > > >mode, finally kernel will trap the exception if the userspace
> > > >libs use SETEND instruction.
> > > >
> > > >So this patch clears bit SCTLR_EL1.SED to support SETEND instruction.
> > > >
> > > The best way to do this, is via the instruction emulation framework
> > > added by Punit, which handles the armv8 deprecated/obsoleted
> > > instructions. This is now queued for 3.19.
> > > I have a patchset which adds the 'SETEND' emulation support to the
> > > framework. This will enable better handling of the feature,
> > > including finding out the users of the deprecated instruction (when
> > > we switch to the emulation mode).
> > > 
> > 
> > i'm a little confuse for this point:
> > 
> > if the deprecated instructions cannot be supported by CPU, then only
> > can use emulation; on the other hand, if CPU can natively support the
> > deprecated instruction, why we cannot directly enable this h/w feature?
> > if use the emulation mode, suppose here will have performance penalty.
> > 
> > how about u think for this? :-)
> 
> A *huge* advantage of emulation is that we can print a diagnostic to dmesg
> warning the user that they are making use of a CPU feature that is likely to
> disappear from future revisions of the hardware. We've not been great at
> doing this in the past, which led to all the fun around SWP emulation that
> you can find in the list archives.
> 
> Furthermore, I think the emulation framework does allow the hardware support
> to be enabled, it just doesn't make that the default behaviour.
> 
> In other words; use the emulation to find out where SETEND is being used
> and fix those applications wherever you can. In the cases where you're
> stuck with a legacy binary, you can enable CPU support if it is available
> but that's not a longterm solution.
> 

Thanks for clarification; Let's use emulation framework as formal method.

Thanks,
Leo Yan
