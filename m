Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaI2RzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:55:04 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45401 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaI2RzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140929162714.GH7996@ZenIV.linux.org.uk>
References: <20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<20140928074747.GZ7996@ZenIV.linux.org.uk>
	<20140928180556.GA7996@ZenIV.linux.org.uk>
	<CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
	<20140929155918.GG7996@ZenIV.linux.org.uk>
	<CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
	<20140929162714.GH7996@ZenIV.linux.org.uk>
Date: Mon, 29 Sep 2014 10:54:59 -0700
X-Google-Sender-Auth: RSmz9nAFtNNw2aZedXGKzveoWBY
Message-ID: <CA+55aFxeD-m0ddKrYr9-A804rqvdvPB-aczV=HV=5hqpK7-XyQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 9:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What we get in free_dentry() is:
>         * external name not shared: refcount driven to 0, RCU-delayed
> call of "free dentry, free ext name"
>         * external name still shared: refcount positive after decrement,
> no freeing ext name
>         * no external name: no ext name to free
> In the last two cases we do what dentry_free() used to do, except that now
> __d_free() doesn't even look for ext name.  Just frees the dentry.  If
> it never had been hashed - directly called, otherwise - via call_rcu().
>
> Does that look OK for you?

Yes. That looks fairly straightforward.

Although please rename that "ext" in ext_name/__d_free_ext() to
something else. "ext" to me says not "external", but "extended". I
think we can just write out "external", like we already do in
"dname_external()".

                   Linus
