Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaB0WAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:00:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:28229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaB0WAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:00:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="491159126"
Message-ID: <530FB55F.2070106@linux.intel.com>
Date: Thu, 27 Feb 2014 13:59:59 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
CC: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com> <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 11:53 AM, Kirill A. Shutemov wrote:
> +#define FAULT_AROUND_ORDER 4
> +#define FAULT_AROUND_PAGES (1UL << FAULT_AROUND_ORDER)
> +#define FAULT_AROUND_MASK ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1)

Looking at the performance data made me think of this: do we really want
this to be static?  It seems like the kind of thing that will cause a
regression _somewhere_.

Also, the folks with larger base bage sizes probably don't want a
FAULT_AROUND_ORDER=4.  That's 1MB of fault-around for ppc64, for example.
