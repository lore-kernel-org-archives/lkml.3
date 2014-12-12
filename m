Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966478AbaLLGyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:54:22 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59386 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966383AbaLLGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:54:16 -0500
Date: Fri, 12 Dec 2014 07:54:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212065411.GA27967@gmail.com>
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <548A122C.8000906@oracle.com>
 <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
 <548A2165.9030107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548A2165.9030107@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> Right, and it reproduces in 3.10 as well, so it's not really a 
> new thing.
> 
> What's odd is that I don't remember seeing this bug so long in 
> the past, I'll try bisecting trinity rather than the kernel - 
> it's the only other thing that changed.

So I think DaveJ mentioned it that Trinity recently changed its 
test task count and is now more aggressively loading the system. 
Such a change might have made a dormant, resource limits related 
bug or load dependent race more likely.

I think at this point it would also be useful to debug the hang 
itself directly: using triggered printks and kgdb and drilling 
into all the data structures to figure out why the system isn't 
progressing.

If the bug triggers in a VM (which your testing uses) the failed 
kernel state ought to be a lot more accessible than bare metal.

That it triggers in a VM, and if it's the same bug as DaveJ's, 
that also makes the hardware bug theory a lot less likely.

Thanks,

	Ingo
