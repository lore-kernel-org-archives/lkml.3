Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaJRSY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 14:24:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51712 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJRSY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 14:24:57 -0400
Date: Sat, 18 Oct 2014 19:24:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
Message-ID: <20141018182454.GF7996@ZenIV.linux.org.uk>
References: <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
 <542BE551.1010705@parallels.com>
 <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
 <543F9E75.2090509@parallels.com>
 <CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
 <CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
 <20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
 <CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
 <CAJfpegvrOKL6Yi1YoZeyQm1CdQoNyYo6_rv3AVhsNnQes0NyBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvrOKL6Yi1YoZeyQm1CdQoNyYo6_rv3AVhsNnQes0NyBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 08:01:13PM +0200, Miklos Szeredi wrote:

> And what you don't get is that there's a deep difference between those
> and the /proc file access case.
> 
> And the difference is that one is done because of an explicit action
> by the holder of the open file.  And the other is done by some random
> process doing non-invasive examination of the holder of the open-file.

Such as ls -l /proc/*/fd/*?  That will give you the same transient EBUSY
from umount, if it hits the right moment...
