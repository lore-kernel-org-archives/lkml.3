Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaCHUC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:02:29 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:65526 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaCHUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:02:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140308194405.GA32403@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	<20140308184040.GA29602@redhat.com>
	<CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	<20140308194405.GA32403@redhat.com>
Date: Sat, 8 Mar 2014 12:02:27 -0800
X-Google-Sender-Auth: WoJwC8l_gNW3mdjqIjFKJ5cnNuw
Message-ID: <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 11:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Sure. But another thread or CLONE_VM task can do vmacache_invalidate(),
> hit vmacache_seqnum == 0 and call vmacache_flush_all() to solve the
> problem with potential overflow.

How?

Any invalidation is supposed to hold the mm semaphore for writing. And
we should have it for reading.

That said, maybe we don't. Maybe we only get it in the dup_mm() path,
I didn't check. In that case, we should probably either get it, or do
some silly memory barrier thing ("check that the sequence number
didn't change between copying the cache and exposing the new thread").

            Linus
