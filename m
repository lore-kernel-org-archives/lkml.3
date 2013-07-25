Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3GYHHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:07:24 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53982 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3GYHHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:07:22 -0400
Date: Thu, 25 Jul 2013 11:07:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130725070719.GB27992@moon>
References: <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
 <20130724171728.GH8508@moon>
 <1374687373.7382.22.camel@dabdike>
 <CALCETrV5MD1qCQsyz4=t+QW1BJuTBYainewzDfEaXW12S91K=A@mail.gmail.com>
 <20130724181516.GI8508@moon>
 <CALCETrV5NojErxWOc2RpuYKE0g8FfOmKB31oDz46CRu27hmDBA@mail.gmail.com>
 <20130724185256.GA24365@moon>
 <51F0232D.6060306@parallels.com>
 <20130724190453.GJ8508@moon>
 <CALCETrVRQBLrQBL8_Zu0VqBRkDXXr2np57-gt4T59A4jG9jMZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVRQBLrQBL8_Zu0VqBRkDXXr2np57-gt4T59A4jG9jMZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:40:22PM -0700, Andy Lutomirski wrote:
> 
> Hmm.  So there are at least three kinds of memory:
> 
> Anonymous pages: soft-dirty works
> Shared file-backed pages: soft-dirty does not work
> Private file-backed pages: soft-dirty works (but see below)
> 
> Perhaps another bit should be allocated to expose to userspace either
> "soft-dirty", "soft-clean", or "soft-dirty unsupported"?

> There's another possible issue with private file-backed pages, though:
> how do you distinguish clean-and-not-cowed from cowed-but-soft-clean?
> (The former will reflect changes in the underlying file, I think, but
> the latter won't.)

When fault happens with cow allocation (on write) the pte get soft dirty
bit set (the code uses pte_mkdirty(entry) in __do_fault) and until we
explicitly clean the bit it remains set. Or you mean something else?
