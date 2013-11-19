Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3KSIbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:31:00 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:40365 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KSIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:30:57 -0500
Date: Tue, 19 Nov 2013 09:30:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        kirill.shutemov@linux.intel.com, dave.hansen@intel.com,
        mingo@redhat.com, n-horiguchi@ah.jp.nec.com, willy@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86, mm: get ASLR work for hugetlb mappings
Message-ID: <20131119083053.GB1243@gmail.com>
References: <20131115221406.1692E1E418F@corp2gmr1-2.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115221406.1692E1E418F@corp2gmr1-2.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Subject: x86, mm: get ASLR work for hugetlb mappings
> 
> Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.  The
> reason is genereic hugetlb_get_unmapped_area() which is used on x86-64. 
> It doesn't support randomization and use bottom-up unmapped area lookup,
> instead of usual top-down on x86-64.
> 
> x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> x86-32.
> 
> Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.  It
> fixes the issue and make hugetlb use top-down unmapped area lookup.

So the title and the changelog has typos (I counted three), which 
makes me wonder how well this was tested.

To show/document the testing effort a before/after /proc/PID/maps 
output showing hugetlb vma addresses would be nice, showing that ASLR 
didn't work before and that it works adequately after the patch.

A word about the range and granularity of randomization in the typical 
case would be nice as well.

Thanks,

	Ingo
