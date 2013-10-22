Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3JVPWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:22:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:45186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3JVPWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396799808"
Message-ID: <526697F5.7040800@intel.com>
Date: Tue, 22 Oct 2013 08:21:25 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Nadia Yvette Chambers <nyc@holomorphy.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86, mm: get ASLR work for hugetlb mappings
References: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 06:52 AM, Kirill A. Shutemov wrote:
> Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
> The reason is genereic hugetlb_get_unmapped_area() which is used on
> x86-64. It doesn't support randomization and use bottom-up unmapped area
> lookup, instead of usual top-down on x86-64.

I have to wonder if this was on purpose in order to keep the large and
small mappings separate.  We don't *have* to keep them separate this, of
course, but it makes me wonder.

> x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> x86-32.
> 
> Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
> It fixes the issue and make hugetlb use top-down unmapped area lookup.

Shouldn't we fix the generic code instead of further specializing the
x86 stuff?

In any case, you probably also want to run this through: the
libhugetlbfs tests:

http://sourceforge.net/p/libhugetlbfs/code/ci/master/tree/tests/
