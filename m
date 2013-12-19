Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3LSPdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:33:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab3LSPde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:33:34 -0500
Date: Thu, 19 Dec 2013 16:33:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Timo Teras <timo.teras@iki.fi>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
In-Reply-To: <20131219172644.7bb5f332@vostro>
Message-ID: <alpine.LNX.2.00.1312191631590.11852@pobox.suse.cz>
References: <1380698395-5784-1-git-send-email-timo.teras@iki.fi> <alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz> <20131219164251.3ebd124a@vostro> <alpine.LNX.2.00.1312191558140.11852@pobox.suse.cz> <20131219172644.7bb5f332@vostro>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Timo Teras wrote:

> > > As you see, the main executable is mapped 57620000-57708000 and
> > > 57708000-5770a000. Heap follow immediately after that
> > > 5770a000-5770c000 followed by anything mmaped after it (stack or
> > > some other libraries). Heap can grow only up to 5ffdf000 meaning the
> > > application is limited to 140 megs or so in this instance. This
> > > limit can go much lower depending how the randomization went. And
> > > even 140 megs is very little for big apps.
> > 
> > So what is the real problem again (i.e. the actual symptoms), please?
> > Is it that your userspace memory allocator doesn't use mmap() for
> > allocations at all?
> 
> Random application failures with uclibc and musl c-libraries. Both seem
> to use mmap() for large allocations, and brk() for small ones. IIRC,
> there was also some minor breakage with other applications that use
> brk() to do some self-accounting / other funny stuff.

Hmm, that's really unfortunate. Applications really should be prepared for 
failing brk(), as there is no guarantee provided by anyobody whatsoever 
about the space allocated for the program break.

Heck, even my manpage tells me:

"Avoid using brk() and sbrk(): the malloc(3) memory allocation package is 
 the portable and comfortable  way  of allocating memory."

-- 
Jiri Kosina
SUSE Labs
