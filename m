Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaJRSia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 14:38:30 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55585 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 14:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegvrOKL6Yi1YoZeyQm1CdQoNyYo6_rv3AVhsNnQes0NyBQ@mail.gmail.com>
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
	<CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
	<CAJfpegvrOKL6Yi1YoZeyQm1CdQoNyYo6_rv3AVhsNnQes0NyBQ@mail.gmail.com>
Date: Sat, 18 Oct 2014 11:38:28 -0700
X-Google-Sender-Auth: 1wW3sAE89TX-VJulo3bJsfjKCXY
Message-ID: <CA+55aFzWOp6CgbcezYsjX9Fda2u6MuDKZ5dx=PF3wtRcWabZQA@mail.gmail.com>
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

On Sat, Oct 18, 2014 at 11:01 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> And what you don't get is that there's a deep difference between those
> and the /proc file access case.

No there isn't.

Your "action by the holder" argument is pure and utter garbage, for a
very simple and core reason: the *filesystem* doesn't know or care. So
from a fuse standpoint, the difference is totally and entirely
irrelevant.

Your "synchronous fput" fails. It fails totally regardless of that
"who incremented the file user count" issue. Face it, your patch is
broken. And it's *fundamentally* broken, which is why I'm so tired of
your stupid ad-hoc hacks that cannot possibly work.

Your umount EBUSY case is somewhat relevant to the "who holds the file
open", but quite frankly, that's not a filesystem issue, it's more of
a system management issue. So umount might get EBUSY. That's not
something the filesystem should/could care about, that's a MIS issue
that is entirely irrelevant, and the answer is "if somebody does lsof,
that might keep the filesystem busy". Tough.

             Linus
