Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaCCWWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:22:19 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61135 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaCCWWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:22:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140303221014.GN18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
	<CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
	<CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
	<20140303214536.GK18016@ZenIV.linux.org.uk>
	<CA+55aFwZ_tcK+G2SZynDzv6w=y3UNobVE5SOH9+Y6x2QQCW7tA@mail.gmail.com>
	<20140303221014.GN18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 14:22:16 -0800
X-Google-Sender-Auth: 9PdLAt10__lRqjgi7BTyaXw4Hao
Message-ID: <CA+55aFzhmPbBS9dY9LFvPo4+VvihSTUa7w7twETG2hs86KWnuA@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 2:10 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> It can - compat read/write/read/writev are also there these days.

There is no "compat_read/write()" - or I would have noticed it when
grepping. Regular read/write is fine for the compat case.

It's only readv/writev that have compat versions, because the vectors
need to be converted,

                 Linus
