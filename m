Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3IMOW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:22:58 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44437 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3IMOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130913113051.GA8189@gondor.apana.org.au>
References: <20100903060055.GA28915@gondor.apana.org.au>
	<20100903110722.GA31826@gondor.apana.org.au>
	<20101215115035.GA25248@gondor.apana.org.au>
	<20110216053911.GA10999@gondor.apana.org.au>
	<20110328071322.GA6569@gondor.apana.org.au>
	<20110629235153.GA16559@gondor.apana.org.au>
	<20120126024342.GA12492@gondor.apana.org.au>
	<20120823083242.GA23102@gondor.apana.org.au>
	<20121109093005.GA25632@gondor.apana.org.au>
	<20130328082841.GA7425@gondor.apana.org.au>
	<20130913113051.GA8189@gondor.apana.org.au>
Date: Fri, 13 Sep 2013 07:22:55 -0700
X-Google-Sender-Auth: PFBCmGh8WHTZbGx4YLYhEnVztkQ
Message-ID: <CA+55aFyp8mfqWb2CNyCKgMtAn88a5i+MLshq0DjYEmW7FNoZXA@mail.gmail.com>
Subject: Re: Crypto Fixes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 4:30 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Herbert Xu (2):
>       crypto: api - Fix race condition in larval lookup
>       crypto: crct10dif - Add fallback for broken initrds
>
>  crypto/Makefile                             |    2 +-
>  crypto/api.c                                |    7 +-
>  crypto/{crct10dif.c => crct10dif_common.c}  |  100 +--------------------------
>  crypto/{crct10dif.c => crct10dif_generic.c} |   53 +-------------
>  lib/crc-t10dif.c                            |   11 ++-
>  5 files changed, 20 insertions(+), 153 deletions(-)

Please fix your script. You apparently have it using "-C" to find
copies, which can be very useful to see what is going on especially
with "--summary" (which you don't have), but is misleading when
sending diffstats when people don't expect it.

The pull request does not have "20 insertions", it has "146
insertions", and it's just that a fair chunk of them come from a file
being essentially duplicated. See the difference:

With copy detection ("git diff -C --stat --summary")
 crypto/Makefile                             |   2 +-
 crypto/api.c                                |   7 +-
 crypto/{crct10dif.c => crct10dif_common.c}  | 100 +-------------------
 crypto/{crct10dif.c => crct10dif_generic.c} |  53 +----------
 lib/crc-t10dif.c                            |  11 ++-
 5 files changed, 20 insertions(+), 153 deletions(-)
 copy crypto/{crct10dif.c => crct10dif_common.c} (63%)
 rename crypto/{crct10dif.c => crct10dif_generic.c} (55%)

With just rename detection (git diff -M --stat --summary)
 crypto/Makefile                            |   2 +-
 crypto/api.c                               |   7 +-
 crypto/{crct10dif.c => crct10dif_common.c} | 100 +---------------
 crypto/crct10dif_generic.c                 | 127 +++++++++++++++++++++
 lib/crc-t10dif.c                           |  11 +-
 5 files changed, 146 insertions(+), 101 deletions(-)
 rename crypto/{crct10dif.c => crct10dif_common.c} (63%)
 create mode 100644 crypto/crct10dif_generic.c

and your pull request looked really misleading because it did "-C" but
didn't have that summary pointing out that one of them was a copy.

So please use "-M --stat --summary". That's what git shows me when I
do a "git pull", so that's what I'm going to compare with..

As mentioned "-C" _is_ useful, but it's useful when you're
specifically looking for "that's a lot of new lines, is it copying old
files" kind of things.

                  Linus
