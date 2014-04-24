Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaDXIt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:49:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaDXIt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:49:27 -0400
Date: Thu, 24 Apr 2014 09:49:23 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, riel@redhat.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 3/6] x86: mm: fix missed global TLB flush stat
Message-ID: <20140424084922.GR23991@suse.de>
References: <20140421182418.81CF7519@viggo.jf.intel.com>
 <20140421182422.DE5E728F@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140421182422.DE5E728F@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 11:24:22AM -0700, Dave Hansen wrote:
> 
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

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
