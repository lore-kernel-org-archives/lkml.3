Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaIEJh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:37:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40155 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841AbaIEJhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:37:24 -0400
Date: Fri, 5 Sep 2014 10:36:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Message-ID: <20140905093647.GH2172@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-2-git-send-email-rric@kernel.org>
 <20140905083932.GD13515@arm.com>
 <20140905092135.GR4703@rric.localhost>
 <20140905092507.GH13515@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905092507.GH13515@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:25:08AM +0100, Will Deacon wrote:
> On Fri, Sep 05, 2014 at 10:21:35AM +0100, Robert Richter wrote:
> > On 05.09.14 09:39:32, Will Deacon wrote:
> > > On Fri, Sep 05, 2014 at 08:46:42AM +0100, Robert Richter wrote:
> > > > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > > > 
> > > > Increase maximum numbers of cpus to 32. This relates to current
> > > > maximal possible cpu number. Increasing this to 64 cpus will be a
> > > > separate patch not part of this enablement patches.
> > > 
> > > Just out of interest, does raising the current maximum limit actually break
> > > any existing code? If not, then doing this as two patches doesn't seem worth
> > > it.
> > 
> > Increasing to 64 should be fine from the perspective of cpu mask
> > implementation. Memory foot print should be the same already as this
> > uses long which is 64 bit. So this wouldn't hurt.
> > 
> > However, I felt a bit uncomfortable having a dependency here to
> > enabling 64 cpus and getting this patch set upstream. Support for more
> > than 32 cpus is not well tested yet and there still might be problems
> > with e.g. interrupt delivery or topology.
> 
> All I mean is, if the kernel doesn't explode on existing systems by changing
> the upper limit to 64, then we should do that. If you're not comfortable
> that the Thunder code can handle that, then leave the thunder default as 32,
> like you do in the current patch. It just seems odd not to change the
> maximum number, since it's an arbitrary limit from my perspective.

FWIW my Juno happily boots with a NR_CPUS=64 kernel.

Mark.
