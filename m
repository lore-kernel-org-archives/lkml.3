Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbaD2Osg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:48:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43810 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750952AbaD2Ose (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:48:34 -0400
Date: Tue, 29 Apr 2014 15:47:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
Subject: Re: [PATCH v4 4/7] arm64: Add a description on 48-bit address space
 with 4KB pages
Message-ID: <20140429144759.GL17007@arm.com>
References: <000401cf6367$cc461500$64d23f00$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401cf6367$cc461500$64d23f00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:59:27AM +0100, Jungseok Lee wrote:
> --- a/Documentation/arm64/memory.txt
> +++ b/Documentation/arm64/memory.txt
> @@ -8,10 +8,11 @@ This document describes the virtual memory layout used by the AArch64
>  Linux kernel. The architecture allows up to 4 levels of translation
>  tables with a 4KB page size and up to 3 levels with a 64KB page size.
>  
> -AArch64 Linux uses 3 levels of translation tables with the 4KB page
> -configuration, allowing 39-bit (512GB) virtual addresses for both user
> -and kernel. With 64KB pages, only 2 levels of translation tables are
> -used but the memory layout is the same.
> +AArch64 Linux uses 3 levels and 4 levels of translation tables with
> +the 4KB page configuration, allowing 39-bit (512GB) and 48-bit (256TB)
> +virtual addresses, respectively, for both user and kernel. With 64KB
> +pages, only 2 levels of translation tables are used but the memory layout
> +is the same.

Any reason why we couldn't use 48-bit address space with 64K pages
(implying 3 levels)?

> -AArch64 Linux memory layout with 64KB pages:
> +AArch64 Linux memory layout with 4KB pages + 4 levels:
> +
> +Start			End			Size		Use
> +-----------------------------------------------------------------------
> +0000000000000000	0000ffffffffffff	 256TB		user
> +
> +ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc

BTW, maybe as a separate patch we should change the "end" to be
exclusive. It becomes harder to modify (I've been through this a few
times already ;)) and even follow the changes.

-- 
Catalin
