Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaCEIoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:44:05 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49746 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEIoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:44:04 -0500
Date: Wed, 5 Mar 2014 09:43:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86, random: Enable the RDSEED instruction
Message-ID: <20140305084359.GA2705@gmail.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
 <1393972815-16689-2-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393972815-16689-2-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Upcoming Intel silicon adds a new RDSEED instruction.  Whereas RDRAND
> returns output from a PRNG, the RDSEED instruction returns fully
> conditioned entropy that is suitable for use as seeds to a PRNG.
> 
> The RDSEED instruction takes the same time to execute as RDRAND, but
> RDSEED unlike RDRAND can legitimately return failure (CF=0) due to
> entropy exhaustion if too many threads on too many cores are hammering
> the RDSEED instruction at the same time.  Therefore, we have to be
> more conservative and only use it in places where we can tolerate
> failures.
> 
> This patch introduces the primitives arch_get_random_seed_{int,long}()
> but does not use it yet.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/archrandom.h | 34 +++++++++++++++++++++++++++++++++-
>  include/linux/random.h            | 16 ++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletion(-)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
