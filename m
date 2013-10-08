Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3JHTGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JHTGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:06:06 -0400
Date: Tue, 8 Oct 2013 21:05:23 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008190523.GW30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008075151.GA15689@localhost>
 <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
 <20131008185154.GA8258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008185154.GA8258@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 08:51:54PM +0200, Oleg Nesterov wrote:
> On 10/08, Linus Torvalds wrote:
> >
> > (not yet merged), see:
> >
> >     http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=0c44c2d0f459cd7e275242b72f500137c4fa834d
> 
> I do not really understand inline assembly constraints, but I'll ask
> anyway.
> 
> 	+#define __GEN_RMWcc(fullop, var, cc, ...) \
> 	+do { \
> 	+ asm volatile goto (fullop "; j" cc " %l[cc_label]" \
> 	+ : : "m" (var), ## __VA_ARGS__ \
> 	      ^^^^^^^^^
> 
> don't we need
> 
> 	"+m" (var)
> 
> here?

You actually can't have output operands with asm goto, only inputs
and clobbers.  But the "memory" clobber should be enough here.

If you suspect a compiler bug, can somebody please narrow it down to
a single object file (if I've skimmed the patch right, it is just an
optimization, where object files compiled without and with the patch
should actually coexist fine in the same kernel), ideally to a single
routine if possible and post a preprocessed source + gcc command line
+ version of gcc?

	Jakub
