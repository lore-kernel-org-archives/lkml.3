Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3IHEyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 00:54:38 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:56050 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023Ab3IHEyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 00:54:36 -0400
Date: Sun, 8 Sep 2013 14:54:22 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: race condition in crypto larval handling
Message-ID: <20130908045422.GA31896@gondor.apana.org.au>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
 <20130908013210.GA30627@gondor.apana.org.au>
 <CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
 <20130908043703.GA31554@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130908043703.GA31554@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 02:37:03PM +1000, Herbert Xu wrote:
> On Sat, Sep 07, 2013 at 08:34:15PM -0700, Kees Cook wrote:
> >
> > However, I noticed on the "good" path (even without the above patch),
> > I sometimes see a double-kfree triggered by the modprobe process. I
> > can't, however, see how that's happening, since larval_destroy should
> > only be called when refcnt == 0.
> 
> Do you still see this double free with this patch? Without the
> patch it is completely expected as killing the same lavral twice
> will cause memory corruption leading to all sorts of weirdness,
> even if you stop it from deleting the list entry twice.

Actually I know what it is.  sha512 registers two algorithms.
Therefore, it will create two larvals in sequence and then destroy
them in turn.  So it's not a double free at all.  If you put a
printk in crypto_larval_alloc that should confirm this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
