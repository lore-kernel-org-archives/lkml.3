Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3KDKl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:41:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:64446 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3KDKl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:41:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384327126"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH] x86, mm: get ASLR work for hugetlb mappings
Content-Transfer-Encoding: 7bit
Message-Id: <20131104104152.72F91E0090@blue.fi.intel.com>
Date: Mon,  4 Nov 2013 12:41:52 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
> The reason is genereic hugetlb_get_unmapped_area() which is used on
> x86-64. It doesn't support randomization and use bottom-up unmapped area
> lookup, instead of usual top-down on x86-64.
> 
> x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> x86-32.
> 
> Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
> It fixes the issue and make hugetlb use top-down unmapped area lookup.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>

Andrew, any comments?

-- 
 Kirill A. Shutemov
