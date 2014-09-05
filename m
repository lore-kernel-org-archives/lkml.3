Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaIEJVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:21:43 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52242 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaIEJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:21:41 -0400
Date: Fri, 5 Sep 2014 11:21:35 +0200
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <20140905092135.GR4703@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-2-git-send-email-rric@kernel.org>
 <20140905083932.GD13515@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905083932.GD13515@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.14 09:39:32, Will Deacon wrote:
> On Fri, Sep 05, 2014 at 08:46:42AM +0100, Robert Richter wrote:
> > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > 
> > Increase maximum numbers of cpus to 32. This relates to current
> > maximal possible cpu number. Increasing this to 64 cpus will be a
> > separate patch not part of this enablement patches.
> 
> Just out of interest, does raising the current maximum limit actually break
> any existing code? If not, then doing this as two patches doesn't seem worth
> it.

Increasing to 64 should be fine from the perspective of cpu mask
implementation. Memory foot print should be the same already as this
uses long which is 64 bit. So this wouldn't hurt.

However, I felt a bit uncomfortable having a dependency here to
enabling 64 cpus and getting this patch set upstream. Support for more
than 32 cpus is not well tested yet and there still might be problems
with e.g. interrupt delivery or topology.

If increasing to 32 cpus as an intermediate step isn't the best
approach here, we can live with the current defaults too. I would then
just remove that change from the patch.

For follow on driver patch sets it would be good to have ARCH_THUNDER
upstream as this option will be shared between all drivers.

-Robert
