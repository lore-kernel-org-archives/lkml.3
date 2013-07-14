Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3GNVOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 17:14:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:27634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3GNVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 17:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,664,1367996400"; 
   d="scan'208";a="345506938"
Date: Sun, 14 Jul 2013 14:14:46 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
Message-ID: <20130714211446.GP5643@tassilo.jf.intel.com>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
 <51E2FAB9.9050900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E2FAB9.9050900@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think best would be to just find some way to implement LOCK prefix
patching using atomic compiler intrinsics and then switch to those

Then all this inline assembler horror could be ifdef'ed away 
for old compilers only, and likely the generated code would
be better as the compiler could optimize more.

Or just give up on LOCK patching, as single CPU systems
and VMs are less and less interesting?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
