Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaIQQ2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:28:34 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33801 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:28:33 -0400
Date: Wed, 17 Sep 2014 17:28:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64:free_initrd_mem should also free the memblock
Message-ID: <20140917162822.GB15261@e104818-lin.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB029@CNBJMBX05.corpusers.net>
 <20140915183334.GA30737@arm.com>
 <20140915184023.GF12361@n2100.arm.linux.org.uk>
 <20140915185027.GC30737@arm.com>
 <35FD53F367049845BC99AC72306C23D103D6DB49160C@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB49160C@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 02:53:55AM +0100, Wang, Yalin wrote:
> The reason that a want merge this patch is that
> It confuse me when I debug memory issue by 
> /sys/kernel/debug/memblock/reserved  debug file,
> It show lots of un-correct reserved memory.
> In fact, I also send a patch to cma driver part
> For this issue too:
> http://ozlabs.org/~akpm/mmots/broken-out/free-the-reserved-memblock-when-free-cma-pages.patch
> 
> I want to remove these un-correct memblock parts as much as possible,
> so that I can see more correct info from /sys/kernel/debug/memblock/reserved
> debug file .

Could we not always call memblock_free() from free_reserved_area() (with
a dummy definition when !CONFIG_HAVE_MEMBLOCK)?

-- 
Catalin
