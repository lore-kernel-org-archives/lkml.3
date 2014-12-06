Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaLFBHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 20:07:23 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:62152 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaLFBHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 20:07:21 -0500
MIME-Version: 1.0
In-Reply-To: <1417809545-4540-1-git-send-email-vbabka@suse.cz>
References: <1417809545-4540-1-git-send-email-vbabka@suse.cz>
Date: Fri, 5 Dec 2014 17:07:20 -0800
X-Google-Sender-Auth: fAv3Ofd_NuVHyI4EvBcIkaCbcsc
Message-ID: <CA+55aFwvWk6twgBaevPrF5z_0Faetnh0L19ZokWLidiaAaUmQg@mail.gmail.com>
Subject: Re: [RFC PATCH V2 0/4] Reducing parameters of alloc_pages* family of functions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 11:59 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> Hey all,
>
> this is a V2 of attempting something that has been discussed when Minchan
> proposed to expand the x86 kernel stack [1], namely the reduction of huge
> number of parameters that the alloc_pages* family and get_page_from_freelist()
> functions have.

So I generally like this, but looking at that "struct alloc_context",
one member kind of stands out: the "order" parameter doesn't fit in
with all the other members.

Most everything else is describing where or what kind of pages to work
with. The "order" in contrast, really is separate.

So conceptually, my reaction is that it looks like a good cleanup even
aside from the code/stack size reduction, but that the alloc_context
definition is a bit odd.

Quite frankly, I think the :"order" really fits much more closely with
"alloc_flags", not with the alloc_context. Because like alloc_flags,.
it really describes how we need to allocate things within the context,
I'd argue.

In fact, I think that the order could actually be packed with the
alloc_flags in a single register, even on 32-bit (using a single-word
structure, perhaps). If we really care about number of parameters.

I'd rather go for "makes conceptual sense" over "packs order in
because it kind of works" and we don't modify it".

Hmm?

                       Linus
