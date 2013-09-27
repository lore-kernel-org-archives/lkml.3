Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3I0TDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:03:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45976 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab3I0TDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:03:38 -0400
Date: Fri, 27 Sep 2013 12:03:12 -0700
From: Kees Cook <kees@outflux.net>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Wolfram Gloger <wg@malloc.de>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>, x86@kernel.org
Subject: Re: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
Message-ID: <20130927190312.GV21253@outflux.net>
References: <CACT4Y+Y6r=HV7nFgbu=B=d-4ka3J4yotRjgX1M1xGkNkFn1sOQ@mail.gmail.com>
 <20130910220638.GG11427@tassilo.jf.intel.com>
 <CACT4Y+Y2-d0TFq=oq-xFt8udrYc0r8_aROdUfVU29KJBhwWpAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y2-d0TFq=oq-xFt8udrYc0r8_aROdUfVU29KJBhwWpAQ@mail.gmail.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:16:32PM +0400, Dmitry Vyukov wrote:
> On Wed, Sep 11, 2013 at 2:06 AM, Andi Kleen <ak@linux.intel.com> wrote:
> >> Indeed, get_wchan ensures that fp<stack+THREAD_SIZE, but then dereferences fp+8:
> >>
> >> 434                 if (fp < (unsigned long)stack ||
> >> 435                     fp >= (unsigned long)stack+THREAD_SIZE)
> >> 436                         return 0;
> >> 437                 ip = *(u64 *)(fp+8);
> >>
> >> It must check that fp+8<stack+THREAD_SIZE.
> >> As far as I see, the bug can lead to garbage return values or in the
> >> worst case to crash.
> >
> > Thanks for the report.
> >
> > The change looks good to me. Can you please submit a formal signed off patch
> > to x86@kernel.org ?

Can you CC this to lkml as well? x86@ isn't a public list, IIUC.

Please note that these bounds checks aren't correct to begin with. Since
a pointer is being dereferenced, the end boundry must be reduced by
sizeof(unsigned long) as well.

It looks like process_32.c suffers the same problems, too.

-Kees

-- 
Kees Cook                                            @outflux.net
