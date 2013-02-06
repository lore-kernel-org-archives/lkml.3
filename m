Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3BFCJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:09:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51631 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3BFCJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:09:36 -0500
X-AuditID: 9c930179-b7c24ae00000119c-1e-5111bb5e54aa
Date: Wed, 6 Feb 2013 11:09:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/3] introduce static_vm for ARM-specific static
 mapped area
Message-ID: <20130206020942.GD4325@lge.com>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
 <5110CA8E.5020606@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110CA8E.5020606@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Santosh.

On Tue, Feb 05, 2013 at 02:32:06PM +0530, Santosh Shilimkar wrote:
> On Tuesday 05 February 2013 06:01 AM, Joonsoo Kim wrote:
> >In current implementation, we used ARM-specific flag, that is,
> >VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
> >The purpose of static mapped area is to re-use static mapped area when
> >entire physical address range of the ioremap request can be covered
> >by this area.
> >
> >This implementation causes needless overhead for some cases.
> >For example, assume that there is only one static mapped area and
> >vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
> >deciding whether it is matched or not. Moreover, even if there is
> >no static mapped area and vmlist has 300 areas, every time we call
> >ioremap, we check 300 areas in now.
> >
> >If we construct a extra list for static mapped area, we can eliminate
> >above mentioned overhead.
> >With a extra list, if there is one static mapped area,
> >we just check only one area and proceed next operation quickly.
> >
> >In fact, it is not a critical problem, because ioremap is not frequently
> >used. But reducing overhead is better idea.
> >
> >Another reason for doing this work is for removing vm_struct list management,
> >entirely. For more information, look at the following link.
> >http://lkml.org/lkml/2012/12/6/184
> >
> 
> [..]
> 
> >
> >Joonsoo Kim (3):
> >   ARM: vmregion: remove vmregion code entirely
> >   ARM: ioremap: introduce an infrastructure for static mapped area
> >   ARM: mm: use static_vm for managing static mapped areas
> >
> >  arch/arm/mm/Makefile   |    2 +-
> >  arch/arm/mm/ioremap.c  |  135 +++++++++++++++++++++----------
> >  arch/arm/mm/mm.h       |   12 +++
> >  arch/arm/mm/mmu.c      |   34 ++++----
> >  arch/arm/mm/vmregion.c |  205 ------------------------------------------------
> >  arch/arm/mm/vmregion.h |   31 --------
> >  6 files changed, 123 insertions(+), 296 deletions(-)
> >  delete mode 100644 arch/arm/mm/vmregion.c
> >  delete mode 100644 arch/arm/mm/vmregion.h
> >
> Nice Clean-up. I tested this series on OMAP which uses few static
> mappings. Feel free to add,
> 
> Tested-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

I will re-send v6 with your Tested-by.

Thanks for testing this.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
