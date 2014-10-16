Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaJPUSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaJPUSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:18:37 -0400
Date: Thu, 16 Oct 2014 16:18:23 -0400 (EDT)
Message-Id: <20141016.161823.2256065922400180323.davem@redhat.com>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1410162309560.19924@adalberg.ut.ee>
References: <20141015.231154.1804074463934900124.davem@davemloft.net>
	<alpine.LRH.2.11.1410161021130.5119@adalberg.ut.ee>
	<alpine.LRH.2.11.1410162309560.19924@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Thu, 16 Oct 2014 23:11:49 +0300 (EEST)

>> > Hopefully, this should be a simply matter of doing a complete build
>> > with gcc-4.9, then removing the object file we want to selectively
>> > build with the older compiler and then going:
>> > 
>> > 	make CC="gcc-4.6" arch/sparc/mm/init_64.o
>> > 
>> > then relinking with plain 'make'.
>> > 
>> > If the build system rebuilds the object file on you when you try
>> > to relink the final kernel image, we'll have to do some of this
>> > by hand to make the test.
>> 
>> Unfortunately it starts a full rebuild with plain make after compiling 
>> some files with gcc-4.6 - detects CC change?
> 
> Figured out from make V=1 how to call gcc-4.6 directly, so far my 
> bisection shows that it one or probably more of arch/sparc/kernel/*.c 
> but probably more than 1 - 2 halfs of it both failed. Still bisecting.

Thanks a lot for working this out.

I'm going to also try to setup a test environment so I can try this
gcc-4.9 stuff on my T4-2 as well.
