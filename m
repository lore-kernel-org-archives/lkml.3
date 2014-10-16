Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaJPHXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:23:01 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:33633 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:23:00 -0400
Date: Thu, 16 Oct 2014 10:22:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141015.231154.1804074463934900124.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410161021130.5119@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee> <20141015.143624.941838991598108211.davem@davemloft.net> <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee> <20141015.231154.1804074463934900124.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you happen to have both gcc-4.9 and a previously working compiler
> on these systems?  If you do, we can build a kernel with gcc-4.9 and
> then selectively compile certain failes with the older working
> compiler to narrow down what compiles into something non-working with
> gcc-4.9

Yes, I kept gcc-4.6 to help resolving it.

[...]

> Hopefully, this should be a simply matter of doing a complete build
> with gcc-4.9, then removing the object file we want to selectively
> build with the older compiler and then going:
> 
> 	make CC="gcc-4.6" arch/sparc/mm/init_64.o
> 
> then relinking with plain 'make'.
> 
> If the build system rebuilds the object file on you when you try
> to relink the final kernel image, we'll have to do some of this
> by hand to make the test.

Unfortunately it starts a full rebuild with plain make after compiling 
some files with gcc-4.6 - detects CC change?

-- 
Meelis Roos (mroos@linux.ee)
