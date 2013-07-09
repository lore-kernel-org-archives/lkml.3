Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3GIEMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:12:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60626 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752113Ab3GIEM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:12:29 -0400
Message-ID: <1373343147.9458.25.camel@joe-AO722>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
From: Joe Perches <joe@perches.com>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 21:12:27 -0700
In-Reply-To: <CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
	 <1373173169.1943.1.camel@joe-AO722>
	 <CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 20:51 -0700, Wedson Almeida Filho wrote:
> On Sat, Jul 6, 2013 at 9:59 PM, Joe Perches <joe@perches.com> wrote:
> >
> > Not correct.
> >
> >>       while (start < end) {
> >> -             size_t mid = start + (end - start) / 2;
> >> +             size_t mid = (start + end) / 2;
> >
> >         size_t start = 0x80000000;
> >         size_t end   = 0x80000001;
> 
> Good point, they aren't equivalent in all cases.
> 
> For the overflow to happen though, we need an array with at least
> N/2+1 entries, where N is the address space size. The array wouldn't
> fit in addressable memory if the element size is greater than 1, so
> this can only really happen when the element size is 1. Even then, it
> would require the kernel range to be greater than half of all
> addressable memory, and allow an allocation taking that much memory. I
> don't know all architectures where linux runs, but I don't think such
> configuration is likely to exist.

Nor do I but that wasn't what you wrote.

> There is no functional change, but this change eliminates a subtraction that
> the compiler doesn't optimize out (as of gcc 4.7.3).

That's flatly incorrect.

I don't mind if you change it, for just the reason
you wrote, but you still have to now say under what
conditions the test works and when it doesn't.


