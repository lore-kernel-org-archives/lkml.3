Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3IMOjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:39:17 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:51881 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932109Ab3IMOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:39:15 -0400
Date: Sat, 14 Sep 2013 00:39:08 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.12
Message-ID: <20130913143908.GA11208@gondor.apana.org.au>
References: <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20130913113051.GA8189@gondor.apana.org.au>
 <CA+55aFyp8mfqWb2CNyCKgMtAn88a5i+MLshq0DjYEmW7FNoZXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyp8mfqWb2CNyCKgMtAn88a5i+MLshq0DjYEmW7FNoZXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 07:22:55AM -0700, Linus Torvalds wrote:
> On Fri, Sep 13, 2013 at 4:30 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Herbert Xu (2):
> >       crypto: api - Fix race condition in larval lookup
> >       crypto: crct10dif - Add fallback for broken initrds
> >
> >  crypto/Makefile                             |    2 +-
> >  crypto/api.c                                |    7 +-
> >  crypto/{crct10dif.c => crct10dif_common.c}  |  100 +--------------------------
> >  crypto/{crct10dif.c => crct10dif_generic.c} |   53 +-------------
> >  lib/crc-t10dif.c                            |   11 ++-
> >  5 files changed, 20 insertions(+), 153 deletions(-)
> 
> Please fix your script. You apparently have it using "-C" to find
> copies, which can be very useful to see what is going on especially
> with "--summary" (which you don't have), but is misleading when
> sending diffstats when people don't expect it.

Sorry, will do for future pushes.  FWIW the -M stats are

 crypto/Makefile                            |    2 +-
 crypto/api.c                               |    7 +-
 crypto/{crct10dif.c => crct10dif_common.c} |  100 +---------------------
 crypto/crct10dif_generic.c                 |  127 ++++++++++++++++++++++++++++
 lib/crc-t10dif.c                           |   11 ++-
 5 files changed, 146 insertions(+), 101 deletions(-)
 
> With just rename detection (git diff -M --stat --summary)
>  crypto/Makefile                            |   2 +-
>  crypto/api.c                               |   7 +-
>  crypto/{crct10dif.c => crct10dif_common.c} | 100 +---------------
>  crypto/crct10dif_generic.c                 | 127 +++++++++++++++++++++
>  lib/crc-t10dif.c                           |  11 +-
>  5 files changed, 146 insertions(+), 101 deletions(-)
>  rename crypto/{crct10dif.c => crct10dif_common.c} (63%)
>  create mode 100644 crypto/crct10dif_generic.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
