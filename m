Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3HFU4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:56:39 -0400
Received: from shutemov.name ([204.155.152.216]:36034 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3HFU4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:56:38 -0400
Date: Tue, 6 Aug 2013 23:57:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Ning Qu <quning@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/23] truncate: support huge pages
Message-ID: <20130806205716.GA4031@shutemov.name>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-20-git-send-email-kirill.shutemov@linux.intel.com>
 <52015B54.5010605@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52015B54.5010605@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 01:23:48PM -0700, Dave Hansen wrote:
> On 08/03/2013 07:17 PM, Kirill A. Shutemov wrote:
> > +			if (PageTransTailCache(page)) {
> > +				/* part of already handled huge page */
> > +				if (!page->mapping)
> > +					continue;
> > +				/* the range starts in middle of huge page */
> > +				partial_thp_start = true;
> > +				start = index & ~HPAGE_CACHE_INDEX_MASK;
> > +				continue;
> > +			}
> > +			/* the range ends on huge page */
> > +			if (PageTransHugeCache(page) &&
> > +				index == (end & ~HPAGE_CACHE_INDEX_MASK)) {
> > +				partial_thp_end = true;
> > +				end = index;
> > +				break;
> > +			}
> 
> Still reading through the code, but that "index ==" line's indentation
> is screwed up.  It makes it look like "index == " is a line of code
> instead of part of the if() condition.

I screwed it up myself. Otherwise, the line is too long. :-/

Probably, I should move partial page logic into separate function.

-- 
 Kirill A. Shutemov
