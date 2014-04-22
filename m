Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbaDVQzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbaDVQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:54:58 -0400
Message-ID: <53569ED3.2080206@redhat.com>
Date: Tue, 22 Apr 2014 12:54:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 2/6] x86: mm: rip out complicated, out-of-date, buggy
 TLB flushing
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182421.DFAAD16A@viggo.jf.intel.com>
In-Reply-To: <20140421182421.DFAAD16A@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I think the flush_tlb_mm_range() code that tries to tune the
> flush sizes based on the CPU needs to get ripped out for
> several reasons:
> 
> 1. It is obviously buggy.  It uses mm->total_vm to judge the
>    task's footprint in the TLB.  It should certainly be using
>    some measure of RSS, *NOT* ->total_vm since only resident
>    memory can populate the TLB.
> 2. Haswell, and several other CPUs are missing from the
>    intel_tlb_flushall_shift_set() function.  Thus, it has been
>    demonstrated to bitrot quickly in practice.
> 3. It is plain wrong in my vm:
> 	[    0.037444] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> 	[    0.037444] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> 	[    0.037444] tlb_flushall_shift: 6
>    Which leads to it to never use invlpg.
> 4. The assumptions about TLB refill costs are wrong:
> 	http://lkml.kernel.org/r/1337782555-8088-3-git-send-email-alex.shi@intel.com
>     (more on this in later patches)
> 5. I can not reproduce the original data: https://lkml.org/lkml/2012/5/17/59
>    I believe the sample times were too short.  Running the
>    benchmark in a loop yields times that vary quite a bit.
> 
> Note that this leaves us with a static ceiling of 1 page.  This
> is a conservative, dumb setting, and will be revised in a later
> patch.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
