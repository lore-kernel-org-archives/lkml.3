Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3GXSxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:53:03 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35124 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3GXSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:52:59 -0400
Date: Wed, 24 Jul 2013 22:52:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130724185256.GA24365@moon>
References: <20130724160826.GD24851@moon>
 <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
 <20130724163734.GE24851@moon>
 <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
 <20130724171728.GH8508@moon>
 <1374687373.7382.22.camel@dabdike>
 <CALCETrV5MD1qCQsyz4=t+QW1BJuTBYainewzDfEaXW12S91K=A@mail.gmail.com>
 <20130724181516.GI8508@moon>
 <CALCETrV5NojErxWOc2RpuYKE0g8FfOmKB31oDz46CRu27hmDBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV5NojErxWOc2RpuYKE0g8FfOmKB31oDz46CRu27hmDBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:21:46AM -0700, Andy Lutomirski wrote:
> >
> > I fear for tracking soft-dirty-bit for swapped entries we sinply have
> > no other place than pte (still i'm quite open for ideas, maybe there
> > are a better way which I've missed).
> 
> I know approximately nothing about how swap and anon_vma work.
> 
> For files, sticking it in struct page seems potentially nicer,
> although finding a free bit might be tough.  (FWIW, I have plans to
> free up a page flag on x86 some time moderately soon as part of a
> completely unrelated project.)  I think this stuff really belongs to
> the address_space more than it belongs to the pte.

Well, some part of information already lays in pte (such as 'file' bit,
swap entries) so it looks natural i think to work on this level. but
letme think if use page struct for that be more convenient...

> 
> How do you handle the write syscall?

I fear I somehow miss your point here, could please alaborate a bit?
There is no additional code I know of being write() specific, just
a code for #PF exceptions.
