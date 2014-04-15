Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaDOHwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:52:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46099 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaDOHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:52:14 -0400
Date: Tue, 15 Apr 2014 08:52:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] prefetch result in 64 bit atomic ops
Message-ID: <20140415075220.GC17408@arm.com>
References: <534C2CC2.9050706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C2CC2.9050706@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Mon, Apr 14, 2014 at 07:45:22PM +0100, Pranith Kumar wrote:
> Please disregard previous patches. This is the correct one. 
> 
> prefetch destination as is being done in ARM32 atomic ops

Whilst this looks like a potentially sensible optimisation (based on the
results I saw on AArch32), I don't think we can take this patch without some
benchmarks on real silicon. The interaction between the half-barrier atomic
instructions and prfm isn't immediately obvious to me, and we should also
consider looking at streaming preload vs the l1keep option.

Did you write this patch as a basic port of the arch/arm/ patches I wrote,
or was it based on performance figures from real hardware?

Will
