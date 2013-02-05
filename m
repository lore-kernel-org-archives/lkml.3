Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3BEJBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:01:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40227 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3BEJBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:01:00 -0500
Message-ID: <5110CA8E.5020606@ti.com>
Date: Tue, 5 Feb 2013 14:32:06 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Russell King <linux@arm.linux.org.uk>, <js1304@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/3] introduce static_vm for ARM-specific static mapped
 area
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 06:01 AM, Joonsoo Kim wrote:
> In current implementation, we used ARM-specific flag, that is,
> VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
> The purpose of static mapped area is to re-use static mapped area when
> entire physical address range of the ioremap request can be covered
> by this area.
>
> This implementation causes needless overhead for some cases.
> For example, assume that there is only one static mapped area and
> vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
> deciding whether it is matched or not. Moreover, even if there is
> no static mapped area and vmlist has 300 areas, every time we call
> ioremap, we check 300 areas in now.
>
> If we construct a extra list for static mapped area, we can eliminate
> above mentioned overhead.
> With a extra list, if there is one static mapped area,
> we just check only one area and proceed next operation quickly.
>
> In fact, it is not a critical problem, because ioremap is not frequently
> used. But reducing overhead is better idea.
>
> Another reason for doing this work is for removing vm_struct list management,
> entirely. For more information, look at the following link.
> http://lkml.org/lkml/2012/12/6/184
>

[..]

>
> Joonsoo Kim (3):
>    ARM: vmregion: remove vmregion code entirely
>    ARM: ioremap: introduce an infrastructure for static mapped area
>    ARM: mm: use static_vm for managing static mapped areas
>
>   arch/arm/mm/Makefile   |    2 +-
>   arch/arm/mm/ioremap.c  |  135 +++++++++++++++++++++----------
>   arch/arm/mm/mm.h       |   12 +++
>   arch/arm/mm/mmu.c      |   34 ++++----
>   arch/arm/mm/vmregion.c |  205 ------------------------------------------------
>   arch/arm/mm/vmregion.h |   31 --------
>   6 files changed, 123 insertions(+), 296 deletions(-)
>   delete mode 100644 arch/arm/mm/vmregion.c
>   delete mode 100644 arch/arm/mm/vmregion.h
>
Nice Clean-up. I tested this series on OMAP which uses few static
mappings. Feel free to add,

Tested-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
