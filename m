Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaLGKou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:44:50 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25746 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbaLGKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:44:46 -0500
X-IronPort-AV: E=Sophos;i="5.07,533,1413237600"; 
   d="scan'208";a="111907127"
Date: Sun, 7 Dec 2014 11:44:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
In-Reply-To: <1417765287.2721.39.camel@perches.com>
Message-ID: <alpine.DEB.2.02.1412071140290.2044@localhost6.localdomain6>
References: <1417731809.2721.17.camel@perches.com>  <alpine.DEB.2.02.1412050820290.2059@localhost6.localdomain6> <1417765287.2721.39.camel@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A negative to that approach is inlined functions would
> take the function name of the parent not keep the
> inlined function name.

I tried the following:

#include <stdio.h>

inline int foo() {
  printf("%s %x\n",__func__,0x12345);
}

int main () {
  foo();
}

The assembly code generated for main is:

0000000000400470 <main>:
  400470:       b9 45 23 01 00          mov    $0x12345,%ecx
  400475:       ba 4b 06 40 00          mov    $0x40064b,%edx
  40047a:       be 44 06 40 00          mov    $0x400644,%esi
  40047f:       bf 01 00 00 00          mov    $0x1,%edi
  400484:       31 c0                   xor    %eax,%eax
  400486:       e9 d5 ff ff ff          jmpq   400460 <__printf_chk@plt>

That is, the call to foo seems tom be inlined.

But the output is:

foo 12345

So it seems that __func__ is determined before inlining.

julia
