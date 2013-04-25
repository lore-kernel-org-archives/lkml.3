Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3DYWmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3DYWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:42:19 -0400
Date: Thu, 25 Apr 2013 15:42:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Chanho Min" <chanho.min@lge.com>
Cc: "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Darrick J. Wong'" <djwong@us.ibm.com>,
        "'Bob Pearson'" <rpearson@systemfabricworks.com>,
        "'Richard Weinberger'" <richard@nod.at>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "'Yann Collet'" <yann.collet.73@gmail.com>,
        "'Kyungsik Lee'" <kyungsik.lee@lge.com>,
        "'Linux/m68k'" <linux-m68k@vger.kernel.org>,
        "'sparclinux'" <sparclinux@vger.kernel.org>,
        "'Linux-Next'" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Message-Id: <20130425154217.c54bd65fba92866c309c94fc@linux-foundation.org>
In-Reply-To: <5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 18:22:18 +0900 "Chanho Min" <chanho.min@lge.com> wrote:

> >> +#define HTYPE const u8*
> >> +
> >> +#ifdef __BIG_ENDIAN
> >> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> >> +#else
> >> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> >> +#endif
> >
> >It seems at least m68k and sparc don't have the __builtin_clz() functions:
> >
> >m68k-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572593/):
> >
> >ERROR: "__clzsi2" [lib/lz4/lz4hc_compress.ko] undefined!
> >ERROR: "__clzsi2" [lib/lz4/lz4_compress.ko] undefined!
> 
> gcc seems to define __builtin_clz as __clzsi2 in some architecture. 
> But, kernel doesn't link libgcc.a.
> If kernel should use gcc's built-in function without libgcc.a,
> do we need to port __clzsi2 to 'arch/*/lib/*'?

This breaks alpha (gcc-4.4.4) as well.  Can we please get this fixed
promptly?

