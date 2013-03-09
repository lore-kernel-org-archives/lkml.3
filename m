Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3CIA3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:29:25 -0500
Received: from [140.211.169.12] ([140.211.169.12]:51554 "EHLO
	mail.linuxfoundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754898Ab3CIA3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:29:24 -0500
Date: Fri, 8 Mar 2013 16:29:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christopher Li <sparse@chrisli.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suggestion for fixing the variable length array used in the
 kernel.
Message-Id: <20130308162922.88ad40997d01099949008452@linux-foundation.org>
In-Reply-To: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
References: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 20:46:35 -0800 Christopher Li <sparse@chrisli.org> wrote:

> Hi,
> 
> I am looking at the current sparse warning on the kernel source.
> One category of those warning are produce by the variable length array.
> We all know that the kernel stack has a limit so we don't want to allocate
> too much stack to the variable size array.
> 
> Is there a recommended way to fix those warnings? Is it worth while to
> fix it at all? I am looking forward to some kind of guideline how to handle
> this.

Roughly how many instances of this are there kernel-wide?

I don't think it's good practice in the kernel - it's somewhat
dangerous and the effects of errors will be catastrophic.  And as
you've seen, those sites are difficult to review for safety.

We could just outright ban the thing and convert those sites to
kmalloc() or whatever.  If people howl about the performance impact
(unlikely) then perhaps we can put something together using
__builtin_alloca() which includes runtime checking for "excessive"
allocations.  If an excessive allocation is detected we'd warn and
return NULL.

Anyway, yes, variable-length arrays are problematic so for now, let's
leave the sparse warnings in place?

