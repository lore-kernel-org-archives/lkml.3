Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaDVRPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:15:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaDVRPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:15:53 -0400
Message-ID: <5356A3B6.30006@redhat.com>
Date: Tue, 22 Apr 2014 13:15:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 3/6] x86: mm: fix missed global TLB flush stat
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182422.DE5E728F@viggo.jf.intel.com>
In-Reply-To: <20140421182422.DE5E728F@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> If we take the
> 
> 	if (end == TLB_FLUSH_ALL || vmflag & VM_HUGETLB) {
> 		local_flush_tlb();
> 		goto out;
> 	}
> 
> path out of flush_tlb_mm_range(), we will have flushed the tlb,
> but not incremented NR_TLB_LOCAL_FLUSH_ALL.  This unifies the
> way out of the function so that we always take a single path when
> doing a full tlb flush.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
