Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbaFIQkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:40:16 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33041 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFIQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:40:13 -0400
Date: Mon, 9 Jun 2014 17:40:05 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140609163954.GA22876@linaro.org>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
 <20140609110356.GD25590@arm.com>
 <20140609132429.GF4179@bivouac.eciton.net>
 <20140609133859.GB18487@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609133859.GB18487@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:38:59PM +0100, Catalin Marinas wrote:
> On Mon, Jun 09, 2014 at 02:24:29PM +0100, Leif Lindholm wrote:
> > On Mon, Jun 09, 2014 at 12:03:56PM +0100, Catalin Marinas wrote:
> > > A quick grep through the kernel shows that we have other set_pte() calls
> > > without additional dsb() like create_mapping(), I think kvm_set_pte() as
> > > well.
> > > 
> > > So I'm proposing an alternative patch (which needs some benchmarking as
> > > well to see if anything is affected, maybe application startup time).
> > 
> > I'm happy for any fix which can be included in 3.16.
> 
> Steve Capper made a point about performance. He'll follow up.

Hi :-).
My concern was initially about splitting THPs, as with a 64K granule,
we will have 2048 calls to set_pte_at in a loop. Having thought about
it, these should be relatively rare events though.

There will be an impact on various aspects of the memory system (for
instance fork), but this will need to be measured.

Cheers,
-- 
Steve
