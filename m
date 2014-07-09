Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaGIOsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:48:46 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:60043
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaGIOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:48:44 -0400
Date: Wed, 9 Jul 2014 09:48:41 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 15/21] mm: slub: add kernel address
 sanitizer hooks to slub allocator
In-Reply-To: <1404905415-9046-16-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1407090947020.1384@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-16-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Andrey Ryabinin wrote:

> With this patch kasan will be able to catch bugs in memory allocated
> by slub.
> Allocated slab page, this whole page marked as unaccessible
> in corresponding shadow memory.
> On allocation of slub object requested allocation size marked as
> accessible, and the rest of the object (including slub's metadata)
> marked as redzone (unaccessible).
>
> We also mark object as accessible if ksize was called for this object.
> There is some places in kernel where ksize function is called to inquire
> size of really allocated area. Such callers could validly access whole
> allocated memory, so it should be marked as accessible by kasan_krealloc call.

Do you really need to go through all of this? Add the hooks to
kmem_cache_alloc_trace() instead and use the existing instrumentation
that is there for other purposes?
