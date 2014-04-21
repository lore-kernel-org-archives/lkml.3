Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaDUUsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:48:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39483 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaDUUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:48:36 -0400
Date: Mon, 21 Apr 2014 22:48:35 +0200
From: Pavel Machek <pavel@denx.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Subject: Re: [PATCH 16/28] nios2: System calls handling
Message-ID: <20140421204835.GB22181@amd.pavel.ucw.cz>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-13-git-send-email-lftan@altera.com>
 <20140419160947.GA27776@amd.pavel.ucw.cz>
 <CAFiDJ5-e=vRLxyKuzSQO0vg4HBHessv3xE9SdCQ9zFOqYOreZg@mail.gmail.com>
 <CAFLxGvxXfJNKK=n5tSkjt=zjBT-Auo2mCMf7PQr5skOVxYeW+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvxXfJNKK=n5tSkjt=zjBT-Auo2mCMf7PQr5skOVxYeW+w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> +/* sys_cacheflush -- flush the processor cache. */
> >>> +asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
> >>> +                             unsigned int op)
> >>> +{
> >>> +     struct vm_area_struct *vma;
> >>> +
> >>> +     if (len == 0)
> >>> +             return 0;
> >>
> >> op is being ignored? You should remove it... or if (op) return -EINVAL
> >> if you want future extensions.
> > Yes, op argument is being ignored. Okay, will add the return -EINVAL
> > if op is non-zero.
> 
> Be careful. If existing applications already use this and maybe pass a
> dummy value
> to it you break them.

Well.. of course, but passing ignored integer to syscall, that can be
never used is beyond ugly. NAK-level ugly.

If it is so, you can never ever use the argument, and might as well
remove it (depending on your calling convention, it should not break
anything.)

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
