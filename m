Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbaD1WZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:25:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50518 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaD1WZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <1398723290.25549.20.camel@buesod1.americas.hpqcorp.net>
References: <535EA976.1080402@linux.vnet.ibm.com>
	<CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
	<CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
	<alpine.LSU.2.11.1404281500180.2861@eggly.anvils>
	<1398723290.25549.20.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 28 Apr 2014 15:25:55 -0700
X-Google-Sender-Auth: YzI98GkeJUzHITZE4NY8KZGCsRs
Message-ID: <CA+55aFwGjYS7PqsD6A-q+Yp9YZmiM6mB4MUYmfR7ro02poxxCQ@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Hugh Dickins <hughd@google.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 3:14 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> I think that returning some stale/bogus vma is causing those segfaults
> in udev. It shouldn't occur in a normal scenario. What puzzles me is
> that it's not always reproducible. This makes me wonder what else is
> going on...

I've replaced the BUG_ON() with a WARN_ON_ONCE(), and made it be
unconditional (so you don't have to trigger the range check).

That might make it show up earlier and easier (and hopefully closer to
the place that causes it). Maybe that makes it easier for Srivatsa to
reproduce this. It doesn't make *my* machine do anything different,
though.

Srivatsa? It's in current -git.

            Linus
