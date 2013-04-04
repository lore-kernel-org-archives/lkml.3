Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961Ab3DDSsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:48:04 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:42684 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762667Ab3DDSsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:48:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304041120510.26822@eggly.anvils>
References: <alpine.LNX.2.00.1304041120510.26822@eggly.anvils>
Date: Thu, 4 Apr 2013 11:48:01 -0700
X-Google-Sender-Auth: Mnf4sb7V_ZmC4twe9KXwZX3uRbg
Message-ID: <CA+55aFwCG2h1ijWTCJ38LVcUyczDAfk72c4MVSU+_-BiLoMOOw@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent mmap_cache race in find_vma()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jan Stancek <jstancek@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ian Lance Taylor <iant@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:35 AM, Hugh Dickins <hughd@google.com> wrote:
>
> find_vma() can be called by multiple threads with read lock
> held on mm->mmap_sem and any of them can update mm->mmap_cache.
> Prevent compiler from re-fetching mm->mmap_cache, because other
> readers could update it in the meantime:

Ack. I do wonder if we should mark the unlocked update too some way
(also in find_vma()), although it's probably not a problem in practice
since there's no way the compiler can reasonably really do anything
odd with it. We *could* make that an ACCESS_ONCE() write too just to
highlight the fact that it's an unlocked write to this optimistic data
structure.

Anyway, applied.

                  Linus
