Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaEHQCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:02:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:50178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaEHQCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="537157694"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Armin Rigo <arigo@tunes.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
In-Reply-To: <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
Content-Transfer-Encoding: 7bit
Message-Id: <20140508160205.A0EC7E009B@blue.fi.intel.com>
Date: Thu,  8 May 2014 19:02:05 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Armin Rigo wrote:
> Hi everybody,
> 
> Here is a note from the PyPy project (mentioned earlier in this
> thread, and at https://lwn.net/Articles/587923/ ).
> 
> Yes, we use remap_file_pages() heavily on the x86-64 architecture.
> However, the individual calls to remap_file_pages() are not
> performance-critical, so it is easy to switch to using multiple
> mmap()s.  We need to perform more measurements to know exactly what
> the overhead would be, in terms notably of kernel memory.
> 
> However, an issue with that approach is the upper bound on the number
> of VMAs.  By default, it is not large enough.  Right now, it is
> possible to remap say 10% of the individual pages from an anonymous
> mmap of multiple GBs in size; but doing so with individual calls to
> mmap hits this arbitrary limit.

The limit is not totaly random. We use ELF format for coredumps and ELF has
limitation (16-bit field) on number of sections it can store.

With ELF extended numbering we can bypass 16-bit limit, but some userspace
can be surprised by that.

> I have no particular weight to give
> for or against keeping remap_file_pages() in the kernel, but if it is
> removed or emulated, it would be a plus if the programs would run on a
> machine with the default configuration --- i.e. if you remove or
> emulate remap_file_pages(), please increase the default limit as well.

It's fine to me. Andrew?

-- 
 Kirill A. Shutemov
