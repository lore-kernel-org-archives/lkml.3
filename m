Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFCJML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:12:11 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:55533 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFCJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:12:09 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <15839.1401786056@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<11446.1401420931@jrobl>
	<7184.1401439773@warthog.procyon.org.uk>
	<CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
	<15839.1401786056@warthog.procyon.org.uk>
Date: Tue, 3 Jun 2014 11:12:08 +0200
Message-ID: <CAJfpegsUDcFZ+9jPDU6mMXuAOwvzNFV3Q2WRE6QdoPYSqKeRqQ@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 11:00 AM, David Howells <dhowells@redhat.com> wrote:
> My suspicion is that overlayfs is doing stuff to the lower layer whilst
> holding a lock on the upper layer or vice versa.

No.  It's holding the overlayfs i_mutex and then getting either the
upper *or* the lower i_mutex, but never both.  So it's a simple and
unproblematic ordering.

Thanks,
Miklos
