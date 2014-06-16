Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaFPRIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:08:13 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34980 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753498AbaFPRIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:08:11 -0400
Date: Mon, 16 Jun 2014 18:08:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/24] ILP32 Support in ARM64
Message-ID: <20140616170808.GA5362@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Sat, May 24, 2014 at 12:01:55AM -0700, Andrew Pinski wrote:
> New version of the patches with documentation, signal changes are
> simplified, using less compat syscalls and splitting up the patches so
> it is easier to review.  I have tested LTP on both LP64 and ILP32.
> There is a few LTP failures but they are due to LTP being incorrect
> (sigaction structure in glibc is not the one which is used by the
> kernel)

Do you have more details about what's wrong here and where the fix
should go? LTP? glibc? Kernel?

I'll give you more specific comments on the code in the next couple of
days. But for cosmetics, please wrap the lines around 72 (or whatever)
characters both in emails, commit logs and Documentation/* files (and
you can drop the "Thanks" part in every commit log ;)).

> Andrew Pinski (24):
>   ARM64: Force LP64 to compile the kernel.
>   ARM64: Rename COMPAT to AARCH32_EL0 in Kconfig.
>   ARM64: Change some CONFIG_COMPAT over to use CONFIG_AARCH32_EL0
>     instead.
>   ARM64:ILP32: Set kernel_long to long long so we can reuse most of the
>     same syscalls as LP64.
>   ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32.
>   Allow for some signal structures to be the same between a 32bit ABI
>     and the 64bit ABI.
>   ARM64:ILP32: Use the same size and layout of the signal structures
>     for ILP32 as for LP64.
>   Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to
>     avoid confusion of not splitting the registers.
>   ARM64:ILP32: Use the same syscall names as LP64.
>   ARM64: Introduce is_a32_task and is_a32_thread. Use them in the
>     correct locations.
>   ARM64: Add ARM64_ILP32 to Kconfig.

Does this patch need to be in the middle of the series? It should come
after the ILP32 support is complete.

Thanks.

-- 
Catalin
