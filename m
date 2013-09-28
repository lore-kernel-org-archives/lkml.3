Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3I1VBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:01:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45836 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3I1VBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:01:21 -0400
Date: Sat, 28 Sep 2013 14:01:11 -0700
From: Kees Cook <kees@outflux.net>
To: Wolfram Gloger <wg@malloc.de>
Cc: dvyukov@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        pjt@google.com, andreyknvl@google.com, kcc@google.com, x86@kernel.org
Subject: Re: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
Message-ID: <20130928210111.GZ21253@outflux.net>
References: <20130927190312.GV21253@outflux.net>
 <u4zjqwg1xp.fsf@mail.malloc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u4zjqwg1xp.fsf@mail.malloc.de>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 09:51:14PM +0200, Wolfram Gloger wrote:
> Kees Cook <kees@outflux.net> writes:
> 
> > Please note that these bounds checks aren't correct to begin with. Since
> > a pointer is being dereferenced, the end boundry must be reduced by
> > sizeof(unsigned long) as well.
> >
> > It looks like process_32.c suffers the same problems, too.
> 
> I can't see the end boundary problem in process_32.c.  The end checks
> are properly reduced with the top_esp and top_ebp macros.
> 
> All I can see in process_32.c is that the check
> 
> 		if (bp < stack_page || bp > top_ebp+stack_page)
> 
> could be replaced by:
> 
> 		if (bp < stack_page-sizeof(unsigned long) || bp > top_ebp+stack_page)
> 
> but that is a relaxation and not an over/underrun fix.
> 
> Can you elaborate what problem you see in process_32.c?

Ah, yes, sorry, this appears to only be a problem in process_64.c. I didn't look
closely enough. I see now that top_esp and top_ebp correctly reduce the size of
THREAD_SIZE. Thanks!

-Kees

-- 
Kees Cook                                            @outflux.net
