Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3DVV3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:29:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3DVV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:29:07 -0400
Date: Mon, 22 Apr 2013 14:29:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chanho Min <chanho.min@lge.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Message-Id: <20130422142905.3e4fff72671bb3e245055eee@linux-foundation.org>
In-Reply-To: <CAMuHMdUv=GR6s=BYXHR7KyaKCUSxmkJO8dzZJMRktu3cUCTbsw@mail.gmail.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<51750159.07d70e0a.5461.ffffec64SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAMuHMdUv=GR6s=BYXHR7KyaKCUSxmkJO8dzZJMRktu3cUCTbsw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 11:24:21 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, Apr 22, 2013 at 11:22 AM, Chanho Min <chanho.min@lge.com> wrote:
> >>> +#define HTYPE const u8*
> >>> +
> >>> +#ifdef __BIG_ENDIAN
> >>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> >>> +#else
> >>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> >>> +#endif
> >>
> >>It seems at least m68k and sparc don't have the __builtin_clz() functions:
> >>
> >>m68k-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572593/):
> >>
> >>ERROR: "__clzsi2" [lib/lz4/lz4hc_compress.ko] undefined!
> >>ERROR: "__clzsi2" [lib/lz4/lz4_compress.ko] undefined!
> >
> > gcc seems to define __builtin_clz as __clzsi2 in some architecture.
> > But, kernel doesn't link libgcc.a.
> > If kernel should use gcc's built-in function without libgcc.a,
> > do we need to port __clzsi2 to 'arch/*/lib/*'?
> 
> That's another option.

Without having seen the patch ....  Yes, if we fix it this way then we
also fix it for future callers of __builtin_clz().

