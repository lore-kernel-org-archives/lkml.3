Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3IHEhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 00:37:20 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:59363 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969Ab3IHEhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 00:37:18 -0400
Date: Sun, 8 Sep 2013 14:37:03 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: race condition in crypto larval handling
Message-ID: <20130908043703.GA31554@gondor.apana.org.au>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
 <20130908013210.GA30627@gondor.apana.org.au>
 <CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 08:34:15PM -0700, Kees Cook wrote:
>
> However, I noticed on the "good" path (even without the above patch),
> I sometimes see a double-kfree triggered by the modprobe process. I
> can't, however, see how that's happening, since larval_destroy should
> only be called when refcnt == 0.

Do you still see this double free with this patch? Without the
patch it is completely expected as killing the same lavral twice
will cause memory corruption leading to all sorts of weirdness,
even if you stop it from deleting the list entry twice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
