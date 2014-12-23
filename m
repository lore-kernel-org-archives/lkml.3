Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaLWKzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:55:18 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53174 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLWKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:55:16 -0500
Date: Tue, 23 Dec 2014 10:55:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Fix SCTLR_EL1 initialisation
Message-ID: <20141223105505.GA21816@e104818-lin.cambridge.arm.com>
References: <1418831421-19370-1-git-send-email-suzuki.poulose@arm.com>
 <20141217173915.GF30307@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217173915.GF30307@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 05:39:16PM +0000, Will Deacon wrote:
> On Wed, Dec 17, 2014 at 03:50:21PM +0000, Suzuki K. Poulose wrote:
> > From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> > 
> > We initialise the SCTLR_EL1 value by read-modify-writeback
> > of the desired bits, leaving the other bits (including reserved
> > bits(RESx)) untouched. However, sometimes the boot monitor could
> > leave garbage values in the RESx bits which could have different
> > implications. This patch makes sure that all the bits, including
> > the RESx bits, are set to the proper state, except for the
> > 'endianness' control bits, EE(25) & E0E(24)- which are set early
> > in the el2_setup.
> > 
> > Updated the state of the Bit[6] in the comment to RES0 in the
> > comment.
> > 
> > Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> 
> Looks good to me:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Is this 3.19 material, or simply a cleanup/being cautious?

I'll leave this for the 3.20 merging window.

-- 
Catalin
