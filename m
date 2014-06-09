Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbaFINjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:39:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12140 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbaFINjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:39:12 -0400
Date: Mon, 9 Jun 2014 14:38:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140609133859.GB18487@localhost>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
 <20140609110356.GD25590@arm.com>
 <20140609132429.GF4179@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609132429.GF4179@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:24:29PM +0100, Leif Lindholm wrote:
> On Mon, Jun 09, 2014 at 12:03:56PM +0100, Catalin Marinas wrote:
> > A quick grep through the kernel shows that we have other set_pte() calls
> > without additional dsb() like create_mapping(), I think kvm_set_pte() as
> > well.
> > 
> > So I'm proposing an alternative patch (which needs some benchmarking as
> > well to see if anything is affected, maybe application startup time).
> 
> I'm happy for any fix which can be included in 3.16.

Steve Capper made a point about performance. He'll follow up.

> But is the dsb(ishst) sufficient? We need to also prevent reads from
> overtaking the set_pte(). i.e.:
> 
> ptr = early_ioremap(phys_addr, size);
> if (ptr && strcmp(ptr, "magic") == 0)
>    ...
> 
> Does it not require a dsb(ish)?

So doesn't early_ioremap() now include a dsb() after set_pte() with my
patch?

BTW, according to the ARM ARM (and confirmed with architects), we needs
DSB+ISB even if we have just a data access (rather than instruction
fetch). We have to revisit both 32 and 64-bit code for this.

-- 
Catalin
