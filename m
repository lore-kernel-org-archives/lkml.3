Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3HFUYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:24:09 -0400
Received: from www.sr71.net ([198.145.64.142]:56243 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3HFUYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:24:07 -0400
Message-ID: <52015B54.5010605@sr71.net>
Date: Tue, 06 Aug 2013 13:23:48 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ning Qu <quning@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/23] truncate: support huge pages
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com> <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 07:17 PM, Kirill A. Shutemov wrote:
> +			if (PageTransTailCache(page)) {
> +				/* part of already handled huge page */
> +				if (!page->mapping)
> +					continue;
> +				/* the range starts in middle of huge page */
> +				partial_thp_start = true;
> +				start = index & ~HPAGE_CACHE_INDEX_MASK;
> +				continue;
> +			}
> +			/* the range ends on huge page */
> +			if (PageTransHugeCache(page) &&
> +				index == (end & ~HPAGE_CACHE_INDEX_MASK)) {
> +				partial_thp_end = true;
> +				end = index;
> +				break;
> +			}

Still reading through the code, but that "index ==" line's indentation
is screwed up.  It makes it look like "index == " is a line of code
instead of part of the if() condition.
