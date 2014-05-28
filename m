Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaE1QIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:08:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62637 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753425AbaE1QIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:08:20 -0400
Date: Wed, 28 May 2014 12:08:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        mst@redhat.com, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20140528120817.71921d6a@gandalf.local.home>
In-Reply-To: <CAFLxGvyV2Upn7+uTtScu2_LGazy9L+HU9DWEC==0qyZphCrauA@mail.gmail.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CAFLxGvyV2Upn7+uTtScu2_LGazy9L+HU9DWEC==0qyZphCrauA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 17:43:50 +0200
Richard Weinberger <richard.weinberger@gmail.com> wrote:


> > diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
> > index 8de6d9cf3b95..678205195ae1 100644
> > --- a/arch/x86/include/asm/page_64_types.h
> > +++ b/arch/x86/include/asm/page_64_types.h
> > @@ -1,7 +1,7 @@
> >  #ifndef _ASM_X86_PAGE_64_DEFS_H
> >  #define _ASM_X86_PAGE_64_DEFS_H
> >
> > -#define THREAD_SIZE_ORDER      1
> > +#define THREAD_SIZE_ORDER      2
> >  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> >  #define CURRENT_MASK (~(THREAD_SIZE - 1))
> 
> Do you have any numbers of the performance impact of this?
> 

What performance impact are you looking for? Now if the system is short
on memory, it would probably cause issues in creating tasks. But other
than that, I'm not sure what you are looking for.

-- Steve
