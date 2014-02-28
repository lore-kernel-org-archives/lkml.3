Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaB1XIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:08:25 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:43971 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaB1XIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:08:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140228001039.GB8034@node.dhcp.inet.fi>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+55aFwOe_m3cfQDGxmcBavhyQTqQQNGvACR4YPLaazM_0oyUw@mail.gmail.com>
	<20140228001039.GB8034@node.dhcp.inet.fi>
Date: Fri, 28 Feb 2014 17:08:22 -0600
X-Google-Sender-Auth: 9zC69jUj3bTpXS78o1CQTTdiTNc
Message-ID: <CA+55aFyuspw4viBYbjd=j+zOHe1w-_LMCUHdyTjt4yUqUyosdw@mail.gmail.com>
Subject: Re: [PATCHv3 0/2] mm: map few pages around fault address if they are
 in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 6:10 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> Also Matthew noticed that some drivers do ugly hacks like fault in whole
> VMA on first page fault. IIUC, it's for performance reasons. See
> psbfb_vm_fault() or ttm_bo_vm_fault().

I guarantee it's not for performance reasons, it's probably some other breakage.

And if anything really does want to populate things fully, doing so at
fault time is wrong anyway, you should just use MAP_POPULATE at mmap
time.

So I'll believe the shm/tmpfs issue, and that's "mm internal" anyway.
But random crappy drivers? No way in hell.

               Linus
