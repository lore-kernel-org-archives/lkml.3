Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaFLWHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:07:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:39041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaFLWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,467,1400050800"; 
   d="scan'208";a="556555724"
Message-ID: <539A248F.2090306@intel.com>
Date: Thu, 12 Jun 2014 15:07:11 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 06/11] pagewalk: add size to struct mm_walk
References: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1402609691-13950-7-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402609691-13950-7-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 02:48 PM, Naoya Horiguchi wrote:
> This variable is helpful if we try to share the callback function between
> multiple slots (for example between pte_entry() and pmd_entry()) as done
> in later patches.

smaps_pte() already does this:

static int smaps_pte(pte_t *pte, unsigned long addr, unsigned long end,
                        struct mm_walk *walk)
...
        unsigned long ptent_size = end - addr;

Other than the hugetlb handler, can't we always imply the size from
end-addr?
