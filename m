Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaB0WGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:06:31 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54591 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaB0WGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:06:30 -0500
MIME-Version: 1.0
In-Reply-To: <530FB55F.2070106@linux.intel.com>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
	<530FB55F.2070106@linux.intel.com>
Date: Thu, 27 Feb 2014 14:06:29 -0800
X-Google-Sender-Auth: BqPZZGdnOwlrE4umH74SHVZrQ9o
Message-ID: <CA+55aFzUYTHXcVnZL0vTGRPh3oQ8qYGO9+Va1Ch3P1yX+9knDg@mail.gmail.com>
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 1:59 PM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
> Also, the folks with larger base bage sizes probably don't want a
> FAULT_AROUND_ORDER=4.  That's 1MB of fault-around for ppc64, for example.

Actually, I'd expect that they won't mind, because there's no real
extra cost (the costs are indepenent of page size).

For small mappings the mapping size itself will avoid the
fault-around, and for big mappings they'll get the reduced page
faults.

They chose 64kB pages for a reason (although arguably that reason is
"our TLB fills are horrible crap"), they'll be fine with that "let's
try to map a few pages around us".

That said, making it runtime configurable for testing is likely a good
thing anyway, with some hardcoded maximum fault-around size for
sanity.

              Linus
