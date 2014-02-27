Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaB0V21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:28:27 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60564 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaB0V2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:28:24 -0500
MIME-Version: 1.0
In-Reply-To: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
Date: Thu, 27 Feb 2014 13:28:22 -0800
X-Google-Sender-Auth: Xr3wdp5fubZA5ROVVYJcGW7IIfs
Message-ID: <CA+55aFwOe_m3cfQDGxmcBavhyQTqQQNGvACR4YPLaazM_0oyUw@mail.gmail.com>
Subject: Re: [PATCHv3 0/2] mm: map few pages around fault address if they are
 in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>,
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

On Thu, Feb 27, 2014 at 11:53 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Here's new version of faultaround patchset. It took a while to tune it and
> collect performance data.

Andrew, mind taking this into -mm with my acks? It's based on top of
Kirill's cleanup patches that I think are also in your tree.

Kirill - no complaints from me. I do have two minor issues that you
might satisfy, but I think the patch is fine as-is.

The issues/questions are:

 (a) could you test this on a couple of different architectures? Even
if you just have access to intel machines, testing it across a couple
of generations of microarchitectures would be good. The reason I say
that is that from my profiles, it *looks* like the page fault costs
are relatively higher on Ivybridge/Haswell than on some earlier
uarchs.

   Now, I may well be wrong about the uarch issue, and maybe I just
didn't notice it as much before. I've stared at a lot of profiles over
the years, though, and the page fault cost seems to stand out much
more than it used to. And don't get me wrong - it might not be because
Ivy/Haswell is any worse, it might just be that exception performance
hasn't improved together with some other improvements.

 (b) I suspect we should try to strongly discourage filesystems from
actually using map_pages unless they use the standard
filemap_map_pages function as-is. Even with the fairly clean
interface, and forcing people to use "do_set_pte()", I think the docs
might want to try to more explicitly discourage people from using this
to do their own hacks..

Hmm? Either way, even without those questions answered, I'm happy with
how your patches look.

                    Linus
