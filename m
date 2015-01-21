Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbbAUUsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:48:02 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25032 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbAUUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:47:50 -0500
Message-ID: <54C01051.7000107@oracle.com>
Date: Wed, 21 Jan 2015 15:47:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Chernenkov <dmitryc@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 07/17] mm: slub: add kernel address sanitizer support
 for slub allocator
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com> <1421859105-25253-8-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1421859105-25253-8-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 11:51 AM, Andrey Ryabinin wrote:
> With this patch kasan will be able to catch bugs in memory allocated
> by slub.
> Initially all objects in newly allocated slab page, marked as redzone.
> Later, when allocation of slub object happens, requested by caller
> number of bytes marked as accessible, and the rest of the object
> (including slub's metadata) marked as redzone (inaccessible).
> 
> We also mark object as accessible if ksize was called for this object.
> There is some places in kernel where ksize function is called to inquire
> size of really allocated area. Such callers could validly access whole
> allocated memory, so it should be marked as accessible.
> 
> Code in slub.c and slab_common.c files could validly access to object's
> metadata, so instrumentation for this files are disabled.

This one doesn't apply on -next. Is there a missing commit?

Applying: mm: slub: add kernel address sanitizer support for slub allocator
fatal: sha1 information is lacking or useless (mm/slub.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0007 mm: slub: add kernel address sanitizer support for slub allocator
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".


Thanks,
Sasha
