Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbaGRO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:59:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:22866 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755033AbaGRO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:59:58 -0400
Date: Fri, 18 Jul 2014 15:59:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anup Patel <anup.patel@linaro.org>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>, Loc Ho <lho@apm.com>,
        "ksankaran@apm.com" <ksankaran@apm.com>
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
Message-ID: <20140718145931.GD4608@arm.com>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
 <20140623110937.GB15907@arm.com>
 <1403529423.755.49.camel@deneb.redhat.com>
 <20140624141455.GE4489@arm.com>
 <1403620714.755.69.camel@deneb.redhat.com>
 <20140718110718.GC19850@arm.com>
 <CALrVBkvWejppnR2+Qwc__LT2d=0bQtEwF325kMSmQ=7BeUBrdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrVBkvWejppnR2+Qwc__LT2d=0bQtEwF325kMSmQ=7BeUBrdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:58:31PM +0100, Anup Patel wrote:
> On 18 July 2014 16:37, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > From 133656f8378dbb838ad5f12ea29aa9303d7ca922 Mon Sep 17 00:00:00 2001
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > Date: Fri, 18 Jul 2014 11:54:37 +0100
> > Subject: [PATCH] arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB
> >
> > ZONE_DMA is created to allow 32-bit only devices to access memory in the
> > absence of an IOMMU. On systems where the memory starts above 4GB, it is
> > expected that some devices have a DMA offset hardwired to be able to
> > access the bottom of the memory. Linux currently supports DT bindings
> > for the DMA offsets but they are not (easily) available early during
> > boot.
> >
> > This patch tries to guess a DMA offset and assumes that ZONE_DMA
> > corresponds to the 32-bit mask above the start of DRAM.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Mark Salter <msalter@redhat.com>
[...]
> Linux-3.16-rcX is broken on X-Gene Mustang because
> on X-Gene Mustang the DRAM starts at 0x4000000000.
> 
> I have tested your patch and the original patch from
> this thread. Both patches fixes the issue for X-Gene
> Mustang and Linux-3.16-rc5 happily boots on X-Gene.
> 
> Can you to send your patch as Linux-3.16-rcX fix?

It needs some more testing and if there is time, yes, otherwise it will
just be cc stable.

> For your patch, you can have:
> Tested-by: Anup Patel <anup.patel@linaro.org>

Thanks.

-- 
Catalin
