Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LUCg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:36:26 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45953 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LUCgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:36:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131220213321.32d59343@corrin.poochiereds.net>
References: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
	<20131220173935.0812cc4e.akpm@linux-foundation.org>
	<CA+55aFwwXKAs0dyJJ2FAcJj-okqqLYQsPsSask1p_nXvyrtWXw@mail.gmail.com>
	<20131220213321.32d59343@corrin.poochiereds.net>
Date: Fri, 20 Dec 2013 18:36:24 -0800
X-Google-Sender-Auth: tSSxHwczRDz5S7QXtf0LrozaLno
Message-ID: <CA+55aFyzVE91GZCD7sNzGn4x=MUjXM9SU0a_UFvVVDfxquXMzA@mail.gmail.com>
Subject: Re: Broken initrd compression settings in 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, P J P <ppandit@redhat.com>,
        Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 6:33 PM, Jeff Layton <jlayton@redhat.com> wrote:
>
> Perhaps a better solution for this would be to instead export an
> env var with a list of the compression algorithms that the kernel
> supports. Then installkernel or dracut could use that info to make a
> semi-intelligent decision based on that and what tools are installed.
>
> ...or maybe a separate env var for each one that it supports:
>
>     $INITRD_COMPRESS_LZ4
>     $INITRD_COMPRESS_BZIP2
>     $INITRD_COMPRESS_GZIP
>
> ...etc.

Agreed, either of those would work.

Of course, so does just "distro selects whatever compression method it
thinks is best, and when you compile a kernel for that distro, you
need to make sure that that kernel knows how to uncompress the
initrd".

Which quite frankly is the sanest approach of all. *Especially*
considering that right now we default to supporting all the initrd
compression methods.

And it has the advantage of not needing anything like this at all.

When you compile a kernel, you already need to compile in support for
the stuff the distro needs. This is no different, really.

So I think the whole "kernel tells the distro what compression method
to use" approach is broken and silly, and the wrong way around.

              Linus
