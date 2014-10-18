Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaJRPfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:35:46 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38141 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaJRPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
References: <CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
	<542BE551.1010705@parallels.com>
	<CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
	<543F9E75.2090509@parallels.com>
	<CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
	<CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
	<20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
Date: Sat, 18 Oct 2014 08:35:43 -0700
X-Google-Sender-Auth: u-HJkg-hXrcDD9csCuPuReQuUtw
Message-ID: <CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Maxim Patlasov <mpatlasov@parallels.com>, Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 1:55 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> The problem with those "count elevated by other things" is that they are
> actually bugs.

No they aren't. You think they are, and then you find one case, and
ignore all the others.

Look around for AIO. Look around for the loop driver. Look around for
a number of things that do "fget()" and that you completely ignored.

So no, your patch doesn't change the fundamental issue in any way,
shape, or form.

I asked you to stop emailing me with these broken "let's fix one
special case, because I can't be bothered to understand the big
picture" patches. This was another one of those hacky sh*t patches
that doesn't actually change the deeper issue. Stop it. Seriously.
This idiotic thread has been going on for too long.

              Linus
