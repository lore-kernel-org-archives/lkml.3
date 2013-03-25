Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3CYIP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:15:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:15254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab3CYIP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:15:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="284115138"
Date: Mon, 25 Mar 2013 01:15:56 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 02/29] x86, tsx: Add RTM intrinsics
Message-ID: <20130325081556.GS19692@tassilo.jf.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-3-git-send-email-andi@firstfloor.org>
 <30471.1364182834@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30471.1364182834@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI the TM spec can be downloaded here:
>   https://www.power.org/documentation/power-isa-transactional-memory/
> 
> You're example code looks like this:

I don't think portable code will use this directly. Note it's in arch/x86/

Generally portable code should use higher level interfaces, like
elide_lock/elide_lock_adapt that hide the architecture specific 
details.

If you want to do lock elision you would plug in some elision
algorithm that works well at that level.

> Secondly, can we make xbegin just return true/false and get the status
> later if needed?

I now removed xbegin() from the portable file, as it's only used
in arch specific code. And FWIW I'm considering to change it to save
a few instructions and go for the more efficient goto based 
interface in glibc.

> 
> ppc = tcheck... should be fine, other than the name.

Well x and tm doesn't really matter, but I already have x* so i'm inclined
to keep it, unless people bikeshed too strongly. It should work for PPC too.

BTW if the percpu include loop hell is ever sorted out _xtest may
even stop using XTEST.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
