Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3AOV1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:27:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:22581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3AOV1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:27:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,475,1355126400"; 
   d="scan'208";a="247272309"
From: Andi Kleen <andi@firstfloor.org>
To: John McCorquodale <mcq@rockgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Transparent Hugepage Nit
References: <20130115205041.GA12113@rockgeek.org>
Date: Tue, 15 Jan 2013 13:26:58 -0800
In-Reply-To: <20130115205041.GA12113@rockgeek.org> (John McCorquodale's
	message of "Tue, 15 Jan 2013 13:50:41 -0700")
Message-ID: <m2zk0ayw65.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John McCorquodale <mcq@rockgeek.org> writes:

> Suppose a hugepage-aligned mmap(MAP_ANONYMOUS) mapping has been madvise()d
> HUGEPAGE.  If a subeqeuent call to mremap() grows the mapping and has to
> move the mapping, the hugepage-alignment is not preserved in the choice of 
> new address (in 3.7.2).
>
> I can workaround this by doing a 1-hugepage-oversized remap to find a new 
> aligned address and then size it back down MREMAP_FIXED, but that's probably 
> a lot of frags to 4k pages and back that aren't necessary.
>
> Should it not be the case that mremap(MAYMOVE) on something advised hugepage
> ALWAYS chooses a hugepage-aligned address?  This would be handy when doing the
> initial allocation too: mmap, madvise, mremap (to the same size) to get
> alignment.

The hole searching currently doesn't know anything about transparent
huge pages. There were some discussions on fixing it. But it's
essentially a trade off between memory fragmentation and huge page
optimization: aggressively aligning to 2MB can lose address space
in holes.

Usually if the program uses large enough mappings and enough memory 
it shouldn't be a problem.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
