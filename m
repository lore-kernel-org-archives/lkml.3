Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3EVOU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:20:27 -0400
Received: from www.sr71.net ([198.145.64.142]:52112 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab3EVOUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:20:24 -0400
Message-ID: <519CD42C.6040600@sr71.net>
Date: Wed, 22 May 2013 07:20:28 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 04/39] radix-tree: implement preload for multiple contiguous
 elements
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-5-git-send-email-kirill.shutemov@linux.intel.com> <519BC3BE.3070702@sr71.net> <20130522120356.9CB12E0090@blue.fi.intel.com>
In-Reply-To: <20130522120356.9CB12E0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 05:03 AM, Kirill A. Shutemov wrote:
> On most machines we will have RADIX_TREE_MAP_SHIFT=6. In this case,
> on 64-bit system the per-CPU feature overhead is
>  for preload array:
>    (30 - 21) * sizeof(void*) = 72 bytes
>  plus, if the preload array is full
>    (30 - 21) * sizeof(struct radix_tree_node) = 9 * 560 = 5040 bytes
>  total: 5112 bytes
> 
> on 32-bit system the per-CPU feature overhead is
>  for preload array:
>    (19 - 11) * sizeof(void*) = 32 bytes
>  plus, if the preload array is full
>    (19 - 11) * sizeof(struct radix_tree_node) = 8 * 296 = 2368 bytes
>  total: 2400 bytes
> ---
> 
> Is it good enough?

Yup, just stick the calculations way down in the commit message.  You
can put the description that it "eats about 5k more memory per-cpu than
existing code" up in the very beginning.
