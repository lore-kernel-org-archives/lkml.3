Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaJPULy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:11:54 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41044 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaJPULw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:11:52 -0400
Date: Thu, 16 Oct 2014 23:11:49 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: iamjoonsoo.kim@lge.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <alpine.LRH.2.11.1410161021130.5119@adalberg.ut.ee>
Message-ID: <alpine.LRH.2.11.1410162309560.19924@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee> <20141015.143624.941838991598108211.davem@davemloft.net> <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee> <20141015.231154.1804074463934900124.davem@davemloft.net>
 <alpine.LRH.2.11.1410161021130.5119@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hopefully, this should be a simply matter of doing a complete build
> > with gcc-4.9, then removing the object file we want to selectively
> > build with the older compiler and then going:
> > 
> > 	make CC="gcc-4.6" arch/sparc/mm/init_64.o
> > 
> > then relinking with plain 'make'.
> > 
> > If the build system rebuilds the object file on you when you try
> > to relink the final kernel image, we'll have to do some of this
> > by hand to make the test.
> 
> Unfortunately it starts a full rebuild with plain make after compiling 
> some files with gcc-4.6 - detects CC change?

Figured out from make V=1 how to call gcc-4.6 directly, so far my 
bisection shows that it one or probably more of arch/sparc/kernel/*.c 
but probably more than 1 - 2 halfs of it both failed. Still bisecting.

-- 
Meelis Roos (mroos@linux.ee)
