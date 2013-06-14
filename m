Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3FNOUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:20:43 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64809 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3FNOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130612194005.GC8389@lenny.home.zabbo.net>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
	<20130612181440.GC6151@google.com>
	<20130612182430.GE14404@kvack.org>
	<20130612194005.GC8389@lenny.home.zabbo.net>
Date: Fri, 14 Jun 2013 17:20:40 +0300
Message-ID: <CAE1zotJuQkxqJhV32nAMb-gq3gGzNaL882J4tGoMvj38TMDYMA@mail.gmail.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
From: Octavian Purdila <octavian.purdila@intel.com>
To: Zach Brown <zab@redhat.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:40 PM, Zach Brown <zab@redhat.com> wrote:
>> I've got an alternate approach for fixing this wart in lookup_ioctx()...
>> Instead of using an rbtree, just use the reserved id in the ring buffer
>> header to index an array pointing the ioctx.  It's not finished yet, and
>> it needs to be tidied up, but is most of the way there.
>
> Yeah, that might work.
>
> Note that the patch wasn't using an rbtree, it was storing the pointer
> value in a *radix* which is why single lookups took so long.  Presumably
> radix was used for RCU lookups.
>
> Your ring->id trick lets us use RCU with small ints instead of the
> context pointer.  It might be worth using idr instead of rolling manual
> array code.  It'd still be much faster than the list, but get rid of the
> large alloc, array walking, memcpy(), etc.
>

I picked up Ben's patch and incorporated Zach's idea and the first
results look promising, as expected. I am going to do a full test with
the same workload I've used for rbtree and come back with the results
and the patch in a day or so.

Thanks everybody !
