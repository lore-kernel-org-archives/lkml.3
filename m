Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaEHPp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:45:28 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42719 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEHPp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
From: Armin Rigo <arigo@tunes.org>
Date: Thu, 8 May 2014 17:44:46 +0200
X-Google-Sender-Auth: LvXEG8fNKmPhXM0sKY9RZ8U49S0
Message-ID: <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Here is a note from the PyPy project (mentioned earlier in this
thread, and at https://lwn.net/Articles/587923/ ).

Yes, we use remap_file_pages() heavily on the x86-64 architecture.
However, the individual calls to remap_file_pages() are not
performance-critical, so it is easy to switch to using multiple
mmap()s.  We need to perform more measurements to know exactly what
the overhead would be, in terms notably of kernel memory.

However, an issue with that approach is the upper bound on the number
of VMAs.  By default, it is not large enough.  Right now, it is
possible to remap say 10% of the individual pages from an anonymous
mmap of multiple GBs in size; but doing so with individual calls to
mmap hits this arbitrary limit.  I have no particular weight to give
for or against keeping remap_file_pages() in the kernel, but if it is
removed or emulated, it would be a plus if the programs would run on a
machine with the default configuration --- i.e. if you remove or
emulate remap_file_pages(), please increase the default limit as well.


A bientôt,

Armin.
