Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3H2QSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:18:13 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50418 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3H2QSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:18:11 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <521F4612.9090708@parallels.com>
References: <20130828121920.23965.78383.stgit@maximpc.sw.ru>
	<20130829092533.GA18044@tucsk.piliscsaba.szeredi.hu>
	<521F4612.9090708@parallels.com>
Date: Thu, 29 Aug 2013 18:18:09 +0200
Message-ID: <CAJfpegvLcu1o+FUyRL1phCGMKvB4tReyjMLXBb6JabNJxooRSw@mail.gmail.com>
Subject: Re: [PATCH] fuse: hotfix truncate_pagecache() issue
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 3:01 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> The patch looks fine, but it solves only one side of the problem (exactly
> what you formulated above). Another side is opposite: truncating page cache
> too late, when the state of inode changed significantly. The beginning may
> be as in the scenario above: fuse_dentry_revalidate() discovered that i_size
> changed (due to our own fuse_do_setattr()) and is going to call
> truncate_pagecache() for some 'new_size' it believes valid right now. But by
> the time that particular truncate_pagecache() is called, a lot of things may
> happen:
>
> 1) fuse_do_setattr() called truncate_pagecache() according to your patch
> 2) the file was extended either by write(2) or ftruncate(2) or fallocate(2).
> 3) mmap-ed write make a page in the extended region dirty
>
> The result will be the lost of data user wrote on the step '3)'. (my patch
> solves the issue at least for all cases w/o external changes)

I get it.

Could you please resend the patch with all these failure cases
described in the header?

Thanks,
Miklos
