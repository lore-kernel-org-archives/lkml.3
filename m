Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaEGINZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:13:25 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52142 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaEGINV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:13:21 -0400
Date: Wed, 7 May 2014 01:13:16 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: Re: [PATCH v5 5/6] arm64: mm: Implement 4 levels of translation
 tables
Message-ID: <20140507081316.GI3066@lvm>
References: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
 <20140506104907.GB3066@lvm>
 <001c01cf69ac$01be8bf0$053ba3d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001c01cf69ac$01be8bf0$053ba3d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 01:22:50PM +0900, Jungseok Lee wrote:
> On Tuesday, May 06, 2014 7:49 PM, Christoffer Dall wrote:
> > On Thu, May 01, 2014 at 11:34:16AM +0900, Jungseok Lee wrote:
> > > This patch implements 4 levels of translation tables since 3 levels of
> > > page tables with 4KB pages cannot support 40-bit physical address
> > > space described in [1] due to the following issue.
> > >
> > > It is a restriction that kernel logical memory map with 4KB + 3 levels
> > > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> > > 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> > > mapping for this region in map_mem function since __phys_to_virt for
> > > this region reaches to address overflow.
> > >
> > > If SoC design follows the document, [1], over 32GB RAM would be placed
> > > from 544GB. Even 64GB system is supposed to use the region from 544GB
> > > to 576GB for only 32GB RAM. Naturally, it would reach to enable 4
> > > levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> > >
> > > However, it is recommended 4 levels of page table should be only
> > > enabled if memory map is too sparse or there is about 512GB RAM.
> > 
> > Who recommends this then?  This paragraph just confuses me.
> 
> It is a paraphrase of Catalin's comment:
> "I agree, we should only enable 4-levels of page table if we have close
> to 512GB of RAM or the range is too sparse but I would actually push
> back on the hardware guys to keep it tighter."
> 
> The above message comes from the discussion on 4 levels.
> http://www.spinics.net/linux/lists/arm-kernel/msg319055.html
> 
Hmm, I find it just confusing in the commit message and think it's more
clear if you take it out.  The only relevant bits here are that if you
want to be able to address an address map of a certain size, you need
this feature.  It should be enabled on all systems that have such
address maps to take advantage of the available hardware - arguing to
hardware vendors on which systems to produce is fine, but a Linux commit
message doesn't have to iterate on it - IMHO.

-Christoffer
