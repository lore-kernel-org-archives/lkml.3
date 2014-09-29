Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaI2P07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:26:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:60532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaI2P06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:26:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393083601"
Date: Mon, 29 Sep 2014 08:26:46 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, dave@sr71.net,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        x86@kernel.org, torvalds@linux-foundation.org,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: Re: [PATCH 2/2] x86: Only do a single page fault for
 copy_from_user_nmi
Message-ID: <20140929152646.GC1629@tassilo.jf.intel.com>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-3-git-send-email-andi@firstfloor.org>
 <20140929115620.GH5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929115620.GH5430@worktop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For now, changing the semantics of the function seems like a sure way to
> fail in the future though.

I doubt it. Nearly nobody uses the exact return value semantics.

(iirc it's mostly write() and some bizarre code in mount)

In fact it's a regular mistake to assume it returns -errno.

> > In theory we could also duplicate the whole copy_*_ path for cases
> > where the caller doesn't care about the exact bytes. But that
> > seems overkill for just this issue, and I'm not sure anyone
> > else cares about how fast this is. The simpler check works
> > as well for now.
> 
> So I don't get that code, but why not fix it in general? Taking two
> faults seems silly.

It's really complicated to reconstruct the exact bytes, as an optimized
memcpy is very complicated and has a lot of corner cases. 

I tried it originally when writing the original copy function, but
failed. That is why people came up later with this two-fault
scheme.

I think two fault is fine for most cases, just not for NMIs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
