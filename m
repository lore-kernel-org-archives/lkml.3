Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbaDVVUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbaDVVT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:19:59 -0400
Message-ID: <5356DCEF.3050506@redhat.com>
Date: Tue, 22 Apr 2014 17:19:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/6] x86: mm: trace tlb flushes
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182425.93E696A3@viggo.jf.intel.com>
In-Reply-To: <20140421182425.93E696A3@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> We don't have any good way to figure out what kinds of flushes
> are being attempted.  Right now, we can try to use the vm
> counters, but those only tell us what we actually did with the
> hardware (one-by-one vs full) and don't tell us what was actually
> _requested_.
> 
> This allows us to select out "interesting" TLB flushes that we
> might want to optimize (like the ranged ones) and ignore the ones
> that we have very little control over (the ones at context
> switch).
> 
> Also, since we have a pair of tracepoint calls in
> flush_tlb_mm_range(), we can time the deltas between them to make
> sure that we got the "invlpg vs. global flush" balance correct in
> practice.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
