Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaCCWUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:20:36 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:52157 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaCCWUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140303220905.GM18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
	<CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
	<CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
	<20140303214536.GK18016@ZenIV.linux.org.uk>
	<CA+55aFwGzNdCfENDr0A7EqwkqQ7W8Oc5UzBrZ5Wr_V9LRVcwew@mail.gmail.com>
	<20140303220905.GM18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 14:20:33 -0800
X-Google-Sender-Auth: M60eHwvdE9J_sV7V0vYQE0B1Cpc
Message-ID: <CA+55aFz8U=5WHVdPBExuRLws+ducLPhd-5FEDr=BXXZ+Ruk5FA@mail.gmail.com>
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

On Mon, Mar 3, 2014 at 2:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Yes, but in that case fdget() has grabbed a reference to that sucker,
> so the only way to end with refcount 1 is to have the damn thing gone
> from descriptor table in between.  And AFAICS in that case we are just
> fine without f_pos_lock.

Ahh. Yes, you're right, just checking the file_count() is sufficient,
because as you say, the threaded case will have incremented it for the
case we care about./

              Linus
