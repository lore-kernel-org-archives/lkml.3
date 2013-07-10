Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3GJHBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:01:03 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44087 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3GJHBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:01:01 -0400
Message-ID: <51DD06A9.4030605@kernel.org>
Date: Wed, 10 Jul 2013 10:00:57 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slab tree
References: <20130710125654.dd36f8fb19588697226b99be@canb.auug.org.au>
In-Reply-To: <20130710125654.dd36f8fb19588697226b99be@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 05:56 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the slab tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from include/linux/slab.h:17:0,
>                   from include/linux/crypto.h:24,
>                   from arch/x86/kernel/asm-offsets.c:8:
> include/linux/kmemleak.h: In function 'kmemleak_alloc_recursive':
> include/linux/kmemleak.h:44:16: error: 'SLAB_NOLEAKTRACE' undeclared (first use in this function)
>    if (!(flags & SLAB_NOLEAKTRACE))
>                  ^
> include/linux/kmemleak.h: In function 'kmemleak_free_recursive':
> include/linux/kmemleak.h:50:16: error: 'SLAB_NOLEAKTRACE' undeclared (first use in this function)
>    if (!(flags & SLAB_NOLEAKTRACE))
>                  ^
>
> Probably caused by commit 590a63973e36 ("mm/sl[aou]b: Move kmalloc
> definitions to slab.h").
>
> I have used the slab tree from next-20130709 for today.
>
> And, yes, I am a little annoyed by this.

Yes, it indeed interacts badly with kmemleak and tracing. I reverted the 
commit.

			Pekka

