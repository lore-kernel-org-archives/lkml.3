Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaKRLl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:41:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60063 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaKRLlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:41:25 -0500
Date: Tue, 18 Nov 2014 11:41:20 +0000
From: Will Deacon <will.deacon@arm.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Anton Blanchard <anton@samba.org>, Dan McGee <dpmcgee@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64/mm: Remove hack in mmap randomize layout
Message-ID: <20141118114120.GJ18842@arm.com>
References: <1416265339-8138-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416265339-8138-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 11:02:19PM +0000, Yann Droneaud wrote:
> Since commit 8a0a9bd4db63 ('random: make get_random_int() more
> random'), get_random_int() returns a random value for each call,
> so comment and hack introduced in mmap_rnd() as part of commit
> 1d18c47c735e ('arm64: MMU fault handling and page table management')
> are incorrects.
> 
> Commit 1d18c47c735e seems to use the same hack introduced by
> commit a5adc91a4b44 ('powerpc: Ensure random space between stack
> and mmaps'), latter copied in commit 5a0efea09f42 ('sparc64: Sharpen
> address space randomization calculations.').
> 
> But both architectures were cleaned up as part of commit
> fa8cbaaf5a68 ('powerpc+sparc64/mm: Remove hack in mmap randomize
> layout') as hack is no more needed since commit 8a0a9bd4db63.
> 
> So the present patch removes the comment and the hack around
> get_random_int() on AArch64's mmap_rnd().
> 
> Cc: Dan McGee <dpmcgee@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Fixes: 1d18c47c735e ('arm64: MMU fault handling and page table management')
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  arch/arm64/mm/mmap.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

Thanks, this looks sensible:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
