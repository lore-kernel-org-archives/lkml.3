Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaBZOBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:01:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:7418 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaBZOB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:01:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,548,1389772800"; 
   d="scan'208";a="490111641"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1393422925-22108-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1393422925-22108-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH] mm: disable split page table lock for !MMU
Content-Transfer-Encoding: 7bit
Message-Id: <20140226140040.8E07AE0098@blue.fi.intel.com>
Date: Wed, 26 Feb 2014 16:00:40 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops. CC: lists)

Kirill A. Shutemov wrote:
> There's no reason to enable split page table lock if don't have page
> tables.
> 
> It also triggers build error at least on ARM since we don't define
> pmd_page() for !MMU.
> 
> In file included from arch/arm/kernel/asm-offsets.c:14:0:
> include/linux/mm.h: In function 'pte_lockptr':
> include/linux/mm.h:1392:2: error: implicit declaration of function 'pmd_page' [-Werror=implicit-function-declaration]
> include/linux/mm.h:1392:2: warning: passing argument 1 of 'ptlock_ptr' makes pointer from integer without a cast [enabled by default]
> include/linux/mm.h:1384:27: note: expected 'struct page *' but argument is of type 'int'
> 
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 2d9f1504d75e..90bd85ea6035 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -216,6 +216,7 @@ config PAGEFLAGS_EXTENDED
>  #
>  config SPLIT_PTLOCK_CPUS
>  	int
> +	default "999999" if !MMU
>  	default "999999" if ARM && !CPU_CACHE_VIPT
>  	default "999999" if PARISC && !PA20
>  	default "4"
> -- 
> 1.9.0

-- 
 Kirill A. Shutemov
