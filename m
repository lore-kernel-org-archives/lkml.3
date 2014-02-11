Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBKC5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:57:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaBKC5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:57:23 -0500
Date: Tue, 11 Feb 2014 02:56:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Torsten Duwe <duwe@lst.de>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] powerpc ticket locks
Message-ID: <20140211025645.GJ18016@ZenIV.linux.org.uk>
References: <20140207165801.GC2107@lst.de>
 <1392001823.3996.21.camel@pasglop>
 <20140210155217.GF2107@lst.de>
 <1392086660.3996.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392086660.3996.50.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 01:44:20PM +1100, Benjamin Herrenschmidt wrote:
> That leaves us with 32 bits to put the ref and the owner. The question
> is how big the ref really has to be and can we have a reasonable failure
> mode if it overflows ?
> 
> If we limit ourselves to, for example, 16-bit for the ref in lockref,
> then we can have the second 32-bit split between the owner and the ref.
> 
> If we limit ourselves to 4k CPUs, then we get 4 more bits of ref ...
> 
> So the question is, is it reasonable to have the ref smaller than
> 32-bit...

Every time you open a file, you bump dentry refcount.  Something like
libc or ld.so will be opened on just about every execve(), so I'd say
that 16 bits is far too low.  If nothing else, 32 bits might be too
low on 64bit boxen...
