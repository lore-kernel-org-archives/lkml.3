Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaCaXEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:04:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:7535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaCaXEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,768,1389772800"; 
   d="scan'208";a="503919632"
Date: Mon, 31 Mar 2014 16:03:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, hubicka@ucw.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
Message-ID: <20140331230347.GH32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
 <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I think that adding "visible" to asmlinkage is actively wrong and
> misguided. And the compiler even told you so, but somebody then chose
> to ignore the compiler telling them that they did stupid things.

Hi Linus,

In principle you're right. asmlinkage does not mean visible today.

However with LTO pretty much all asmlinkages have to become 
visible, as they are used by assembler code and we need to
tell that to the compiler, otherwise it'll optimize it away.

So I abused asmlinkage for this.

The alternative would be to add __visible everywhere we
have asmlinkage today. I thought it was the lesser evil
to just add it implicitly.

If you prefer to do it explicitely  I can send 
patches (it would be a very mechanic, long and boring
tree sweep ...).

I can send patches for the warnings. Usually the code
throwing warnings for this has some issue anyways,
or the asmlinkage is not really needed.

Please let me know what you prefer.

-Andi
