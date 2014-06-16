Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaFPVA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:00:29 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:46301 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFPVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:00:28 -0400
Date: Mon, 16 Jun 2014 23:59:46 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] mm, thp: move invariant bug check out of loop in
 __split_huge_page_map
Message-ID: <20140616205946.GB14208@node.dhcp.inet.fi>
References: <1402947348-60655-1-git-send-email-Waiman.Long@hp.com>
 <20140616204934.GA14208@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616204934.GA14208@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:49:34PM +0300, Kirill A. Shutemov wrote:
> On Mon, Jun 16, 2014 at 03:35:48PM -0400, Waiman Long wrote:
> > In the __split_huge_page_map() function, the check for
> > page_mapcount(page) is invariant within the for loop. Because of the
> > fact that the macro is implemented using atomic_read(), the redundant
> > check cannot be optimized away by the compiler leading to unnecessary
> > read to the page structure.

And atomic_read() is *not* atomic operation. It's implemented as
dereferencing though cast to volatile, which suppress compiler
optimization, but doesn't affect what CPU can do with the variable.

So I doubt difference will be measurable anywhere.

-- 
 Kirill A. Shutemov
