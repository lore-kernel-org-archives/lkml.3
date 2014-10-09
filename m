Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaJIIOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:14:25 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44149 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJIIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:14:18 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <542BE551.1010705@parallels.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
	<542BE551.1010705@parallels.com>
Date: Thu, 9 Oct 2014 10:14:17 +0200
Message-ID: <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 1:28 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> Given those patches must die, do you have any ideas how to resolve that
> "spurious EBUSY" problem?

Check the "sync_release" branch of fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git sync_release

And same branch name for libfuse:

  git://git.code.sf.net/p/fuse/fuse sync_release

What it does is send RELEASE from ->flush() after checking the
refcount of file (being careful about RCU accesses).

Lightly tested, more testing, as well as review, is welcome.

Thanks,
Miklos
