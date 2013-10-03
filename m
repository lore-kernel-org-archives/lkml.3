Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3JCFeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:34:16 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:55289 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3JCFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <524CCF38.9000304@zytor.com>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
	<524CCF38.9000304@zytor.com>
Date: Wed, 2 Oct 2013 22:34:13 -0700
X-Google-Sender-Auth: sA3p35jMC6l_5_pzcVbbCF4y4oE
Message-ID: <CA+55aFwKTJp4giDbT6xHZE_o1bzFwDkBAdPvmB3JTpkAEzgYxA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] cross rename
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, "zab@redhat.com" <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 6:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I would suggest it shouldn't be renameat2() but rather renameat3(), i.e.
> rename file A -> B, if B exists rename B to C.  It may not be desirable
> to expose the stale B in the same namespace as A, but still want it to
> be possible to scavenge it.  Obviously, A=C is a valid subcase.

I really *really* prefer to stay with two names. Miklos had an earlier
three-name version, and it was hugely more complex, and it does not
fit nearly as well in the model.

Two directory entries is also what the current rename() effectively
always does (clearing one, changing another). So doing the
cross-rename model is actually fairly close to a normal rename. A
three-way one is not actually at all similar.

So I was actually very relieved to see this much simpler and cleaner
model, because the alternative really was nasty. This one looks fairly
simple and clean and straightforward. The previous was none of that.

              Linus
