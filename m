Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaGUW4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:56:53 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59482 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaGUW4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:56:51 -0400
Date: Mon, 21 Jul 2014 15:56:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Himangi Saraogi <himangi774@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] x86, olpc: Eliminate BUG_ON and memset after
 alloc_bootmem
In-Reply-To: <20140719113637.GA23621@himangi-Dell>
Message-ID: <alpine.DEB.2.02.1407211553190.29389@chino.kir.corp.google.com>
References: <20140719113637.GA23621@himangi-Dell>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Himangi Saraogi wrote:

> alloc_bootmem and related functions never return NULL and always return
> a zeroed region of memory.  Thus a BUG_ON the NULL test or memset after
> calls to these functions is unnecessary.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @@
> expression E;
> statement S;
> @@
> 
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> - BUG_ON (E == NULL);
> 
> @@
> expression E,E1;
> @@
> 
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> - memset(E,0,E1);
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Acked-by: David Rientjes <rientjes@google.com>

Many callers of alloc_bootmem() do not check for the return value because 
of this, there's no fallback available at this part in bootstrap so 
there's nothing else that can be done.
