Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaJPUQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:16:47 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42177 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaJPUQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:16:46 -0400
Date: Thu, 16 Oct 2014 23:16:44 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@redhat.com>
cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141016.160742.1639247937393238792.davem@redhat.com>
Message-ID: <alpine.LRH.2.11.1410162313440.19924@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee> <20141014.173246.921084057467310731.davem@davemloft.net> <alpine.LRH.2.11.1410160956090.13273@adalberg.ut.ee> <20141016.160742.1639247937393238792.davem@redhat.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > scripts/Makefile.build:352: recipe for target 'sound/modules.order' failed
> > make[1]: *** [sound/modules.order] Bus error
> > make[1]: *** Deleting file 'sound/modules.order'
> > Makefile:929: recipe for target 'sound' failed
> 
> I just reproduced this on my Sun Blade 2500, so it can trigger on UltraSPARC-IIIi
> systems too.

My bisection led to the folloowing commit but it seems irrelevant (I 
have no sun4v on these machines):

4ccb9272892c33ef1c19a783cfa87103b30c2784 is the first bad commit
commit 4ccb9272892c33ef1c19a783cfa87103b30c2784
Author: bob picco <bpicco@meloft.net>
Date:   Tue Sep 16 09:26:47 2014 -0400

    sparc64: sun4v TLB error power off events


However, the following chunk sound slightly suspicious:

+       if (fault_code & FAULT_CODE_BAD_RA)
+               goto do_sigbus;
+

because SIGNUS is what I got. For some machines, it killed chekroot 
during startup, for some shells under some circumstances, for some sshd.

-- 
Meelis Roos (mroos@linux.ee)
