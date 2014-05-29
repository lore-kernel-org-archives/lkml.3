Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaE2L0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:26:04 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38800 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbaE2L0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:26:01 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <27746.1401359204@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<25513.1401069402@jrobl>
	<20140528160653.GL17233@tucsk.piliscsaba.szeredi.hu>
	<27746.1401359204@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 13:26:00 +0200
Message-ID: <CAJfpegvQYKHwGh95t2grX4YxZaWd_J+7ZYdHhd0yXn=rKKwkVg@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem v22
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: "J. R. Okajima" <hooanon05g@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, Sedat Dilek <sedat.dilek@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:26 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Perfect solution would be an invisible temp directory.  This needs filesystem
>> support, but perhaps not so difficult.  Again could be done later without
>> backward compatibility issues.
>
> Maybe make a tempfile and hardlink it into place when complete.  That's what
> unionmount is doing.

That doesn't work with RENAME_EXCHANGE, which is what overlayfs uses.

I think that's a small price to pay for not needing to add whiteout
support to every single directory operation.

We could also implement RENAME_EXCHANGE with a tmpfile, but then
again, I think that may be too much complexity for too little gain.

Thanks,
Miklos
