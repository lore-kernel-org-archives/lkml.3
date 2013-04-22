Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3DVJYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:24:25 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:54049 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3DVJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <51750159.07d70e0a.5461.ffffec64SMTPIN_ADDED_BROKEN@mx.google.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<51750159.07d70e0a.5461.ffffec64SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Mon, 22 Apr 2013 11:24:21 +0200
X-Google-Sender-Auth: bSIJTM4wbMWTgaDHdyc-qgUT4Gw
Message-ID: <CAMuHMdUv=GR6s=BYXHR7KyaKCUSxmkJO8dzZJMRktu3cUCTbsw@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:22 AM, Chanho Min <chanho.min@lge.com> wrote:
>>> +#define HTYPE const u8*
>>> +
>>> +#ifdef __BIG_ENDIAN
>>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
>>> +#else
>>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
>>> +#endif
>>
>>It seems at least m68k and sparc don't have the __builtin_clz() functions:
>>
>>m68k-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572593/):
>>
>>ERROR: "__clzsi2" [lib/lz4/lz4hc_compress.ko] undefined!
>>ERROR: "__clzsi2" [lib/lz4/lz4_compress.ko] undefined!
>
> gcc seems to define __builtin_clz as __clzsi2 in some architecture.
> But, kernel doesn't link libgcc.a.
> If kernel should use gcc's built-in function without libgcc.a,
> do we need to port __clzsi2 to 'arch/*/lib/*'?

That's another option.

So far no one used __builtin_c[lt]z in generic code. We always used
__fls and __ffs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
