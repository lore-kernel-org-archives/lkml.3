Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3G3PYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:24:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59611 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3G3PXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:23:48 -0400
Date: Mon, 29 Jul 2013 10:11:04 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/5] Add rbtree postorder iteration functions, runtime
 tests, and update zswap to use.
Message-ID: <20130729151104.GD4381@variantweb.net>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073015-8878-0000-0000-0000082C3292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:13:38PM -0700, Cody P Schafer wrote:
> Postorder iteration yields all of a node's children prior to yielding the node
> itself, and this particular implementation also avoids examining the leaf links
> in a node after that node has been yielded.
> 
> In what I expect will be it's most common usage, postorder iteration allows the

s/it's/its/

> deletion of every node in an rbtree without modifying the rbtree nodes (no
> _requirement_ that they be nulled) while avoiding referencing child nodes after
> they have been "deleted" (most commonly, freed).
> 
> I have only updated zswap to use this functionality at this point, but numerous
> bits of code (most notably in the filesystem drivers) use a hand rolled
> postorder iteration that NULLs child links as it traverses the tree. Each of
> those instances could be replaced with this common implementation.

Thanks for doing this Cody!  Other than the nits I've sent, it looks
good.  Whole set:

Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

> 
> Cody P Schafer (5):
>   rbtree: add postorder iteration functions.
>   rbtree: add rbtree_postorder_for_each_entry_safe() helper.
>   rbtree_test: add test for postorder iteration.
>   rbtree: allow tests to run as builtin
>   mm/zswap: use postorder iteration when destroying rbtree
> 
>  include/linux/rbtree.h | 21 +++++++++++++++++++++
>  lib/Kconfig.debug      |  2 +-
>  lib/rbtree.c           | 40 ++++++++++++++++++++++++++++++++++++++++
>  lib/rbtree_test.c      | 12 ++++++++++++
>  mm/zswap.c             | 15 ++-------------
>  5 files changed, 76 insertions(+), 14 deletions(-)
> 
> -- 
> 1.8.3.4
> 

