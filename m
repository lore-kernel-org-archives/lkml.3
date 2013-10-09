Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3JIBol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:44:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3JIBoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:44:38 -0400
Message-ID: <1381283037.5388.13.camel@marge.simpson.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Mike Galbraith <bitbucket@online.de>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 03:43:57 +0200
In-Reply-To: <20131008190523.GW30970@tucnak.zalov.cz>
References: <20131005234430.GA22485@localhost>
	 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	 <20131008075151.GA15689@localhost>
	 <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	 <20131008185154.GA8258@redhat.com> <20131008190523.GW30970@tucnak.zalov.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:UvBZKMGRR2OHHcT9RdQSSuP1AF6w62AB1uAWV1ZF5Gd
 HRFEwWbMYPH2w3NA229ZlYoIr9/3XwA4JznDg9IZD42Ap3cZgc
 sBn8DYnNW1LodPOfxBe312VN3aQn7kSunexdzdBHnWnO1977il
 JLD3i315W/gtKtTdz721+YwQPDdHP15vnwFXNXD6cuuqDK9pAb
 z19/0Q7EnSoQWGVUz2hPJU5iKmK3YD3jhOPnZZTJYBLA2gCqw4
 gtTD2EtXSqjowwwqGPUUkMIKkSuiX36WN+nhubHz8sr9wbDI7I
 GItVh+oWyB/PAtYfubKwWitPkDq868BkOFdF2tunabg4ys5Eq9
 7RCUa1nvR/anv2TU1WHlJnVlnb0LsHdKUuuPMd9lYD0+Frx03y
 9uqbkcEbbYx8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 21:05 +0200, Jakub Jelinek wrote: 
> On Tue, Oct 08, 2013 at 08:51:54PM +0200, Oleg Nesterov wrote:
> > On 10/08, Linus Torvalds wrote:
> > >
> > > (not yet merged), see:
> > >
> > >     http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=0c44c2d0f459cd7e275242b72f500137c4fa834d
> > 
> > I do not really understand inline assembly constraints, but I'll ask
> > anyway.
> > 
> > 	+#define __GEN_RMWcc(fullop, var, cc, ...) \
> > 	+do { \
> > 	+ asm volatile goto (fullop "; j" cc " %l[cc_label]" \
> > 	+ : : "m" (var), ## __VA_ARGS__ \
> > 	      ^^^^^^^^^
> > 
> > don't we need
> > 
> > 	"+m" (var)
> > 
> > here?
> 
> You actually can't have output operands with asm goto, only inputs
> and clobbers.  But the "memory" clobber should be enough here.
> 
> If you suspect a compiler bug, can somebody please narrow it down to
> a single object file (if I've skimmed the patch right, it is just an
> optimization, where object files compiled without and with the patch
> should actually coexist fine in the same kernel), ideally to a single
> routine if possible and post a preprocessed source + gcc command line
> + version of gcc?

gcc version 4.6.2 (SUSE Linux) won't produce output, but where it dies
might point in the general direction of newer gcc troubles? 

  CC [M]  net/sunrpc/xprtsock.o
net/sunrpc/xprtsock.c: In function ‘xs_setup_tcp’:
net/sunrpc/xprtsock.c:2844:1: internal compiler error: in move_insn, at haifa-sched.c:2353

	-Mike

