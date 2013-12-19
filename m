Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3LSP0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:26:52 -0500
Received: from mail-lb0-f194.google.com ([209.85.217.194]:42072 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3LSP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:26:50 -0500
Date: Thu, 19 Dec 2013 17:26:44 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
Message-ID: <20131219172644.7bb5f332@vostro>
In-Reply-To: <alpine.LNX.2.00.1312191558140.11852@pobox.suse.cz>
References: <1380698395-5784-1-git-send-email-timo.teras@iki.fi>
	<alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz>
	<20131219164251.3ebd124a@vostro>
	<alpine.LNX.2.00.1312191558140.11852@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; i486-alpine-linux-uclibc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 16:02:19 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 19 Dec 2013, Timo Teras wrote:
> 
> > As you see, the main executable is mapped 57620000-57708000 and
> > 57708000-5770a000. Heap follow immediately after that
> > 5770a000-5770c000 followed by anything mmaped after it (stack or
> > some other libraries). Heap can grow only up to 5ffdf000 meaning the
> > application is limited to 140 megs or so in this instance. This
> > limit can go much lower depending how the randomization went. And
> > even 140 megs is very little for big apps.
> 
> So what is the real problem again (i.e. the actual symptoms), please?
> Is it that your userspace memory allocator doesn't use mmap() for
> allocations at all?

Random application failures with uclibc and musl c-libraries. Both seem
to use mmap() for large allocations, and brk() for small ones. IIRC,
there was also some minor breakage with other applications that use
brk() to do some self-accounting / other funny stuff.

While this is not strictly a bug, I would still hope that the memory
layout is configured for maximum compatibility... or do you see it
introducing unwanted side effects?
