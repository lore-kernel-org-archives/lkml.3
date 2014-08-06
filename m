Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbaHFRVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:21:23 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60184 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbaHFRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:21:21 -0400
Date: Wed, 6 Aug 2014 13:21:18 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kees Cook <keescook@chromium.org>
cc: Liu hua <sdu.liu@huawei.com>, Rob Herring <robherring2@gmail.com>,
        wangnan0 <wangnan0@huawei.com>, Laura Abbott <lauraa@codeaurora.org>,
        peifeiyue <peifeiyue@huawei.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>, Rabin Vincent <rabin@rab.in>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "liusdu@126.com" <liusdu@126.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 2/2] ARM : change fixmap mapping region to support 32
 CPUs
In-Reply-To: <CAGXu5jKxtm0YAojOLhd_O9AFUAX+xHgEwwB0W_fpN7Xy8wHphQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1408061317590.6061@knanqh.ubzr>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com> <1397559967-26050-3-git-send-email-sdu.liu@huawei.com> <CAL_JsqKE-L2PN3mXHNdTPMEyTMR9ZtbgGB=O_V6nOXN0YC0a4A@mail.gmail.com> <alpine.LFD.2.11.1405301441210.17310@knanqh.ubzr>
 <CAGXu5j+ga5Enrsd8LuYarGh1Ozakmi3MNw+b9fZ7ubGUJFZY=w@mail.gmail.com> <53E1A3A3.8080706@huawei.com> <CAGXu5jKxtm0YAojOLhd_O9AFUAX+xHgEwwB0W_fpN7Xy8wHphQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Kees Cook wrote:

> With the original code, there is (I think) a page table entry for the
> fixmap range. For the latter, there isn't. I see a NULL pgd entry
> fault when trying to use it, and noticed that this only exists under
> highmem:
> 
> static void __init kmap_init(void)
> {
> #ifdef CONFIG_HIGHMEM
>         pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
>                 PKMAP_BASE, _PAGE_KERNEL_TABLE);
> 
>         fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
>                 FIXADDR_START, _PAGE_KERNEL_TABLE);
> #endif
> }

The above is wrong.  The fixmap PTEs must be allocated unconditionally 
irrespective of highmem.  So the #endif should be moved up by 3 lines.


Nicolas
