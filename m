Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaBGNTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:19:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaBGNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:19:03 -0500
Message-ID: <52F4DD26.4020906@redhat.com>
Date: Fri, 07 Feb 2014 08:18:30 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
In-Reply-To: <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:15 AM, Rashika Kheria wrote:
> The ifdef conditions in include/linux/mm.h presents three cases:
> 
> - !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> There is no actual definition of function but include/linux/mm.h has a
> static inline stub defined.
> 
> - defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> linux/mm.h does not define a prototype, but mm/page_alloc.c defines
> the function.
> Hence, compiler reports the following warning:
> mm/page_alloc.c:4300:15: warning: no previous prototype for ‘__early_pfn_to_nid’ [-Wmissing-prototypes]
> 
> - defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> The architecture defines the function, and linux/mm.h has a prototype.
> 
> Thus, join the conditions of Case 2 and 3 i.e. eliminate the ifdef
> condition of CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID to eliminate the
> missing prototype warning from file mm/page_alloc.c.
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
