Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaJRPkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:40:12 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:48889 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaJRPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
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
	<CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
Date: Sat, 18 Oct 2014 08:40:05 -0700
X-Google-Sender-Auth: xHAoVNwpwOtRr9kf6mg8GOtdYLQ
Message-ID: <CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
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

On Sat, Oct 18, 2014 at 8:35 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Look around for AIO. Look around for the loop driver. Look around for
> a number of things that do "fget()" and that you completely ignored.

.. actually, there are more instances of "get_file()" than of
"fget()", the aio one just happened to be the latter form. Lots and
lots of ways to get ahold of a file descriptor that keeps it open past
the "last close".

               Linus
