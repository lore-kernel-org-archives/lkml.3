Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaI2UpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:45:07 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:59659 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2UpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140929190421.GK7996@ZenIV.linux.org.uk>
References: <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<20140928074747.GZ7996@ZenIV.linux.org.uk>
	<20140928180556.GA7996@ZenIV.linux.org.uk>
	<CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
	<20140929155918.GG7996@ZenIV.linux.org.uk>
	<CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
	<20140929162714.GH7996@ZenIV.linux.org.uk>
	<CA+55aFxeD-m0ddKrYr9-A804rqvdvPB-aczV=HV=5hqpK7-XyQ@mail.gmail.com>
	<20140929190421.GK7996@ZenIV.linux.org.uk>
Date: Mon, 29 Sep 2014 13:45:03 -0700
X-Google-Sender-Auth: S3pGXpYjYTP75JErz9wMUIoQFlk
Message-ID: <CA+55aFx1B_ULXd5iP8UikWrviqP7fxwsDT6jwqqNHLcrOh7YUw@mail.gmail.com>
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

On Mon, Sep 29, 2014 at 12:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> "dname_external()".
>
> That we do...  Why is it in dcache.h, BTW?  No users outside of fs/dcache.c
> and I can't imagine a valid use for it in a module, let alone out-of-tree
> one...

Yeah, no, remove the declaration in dcache.h, and make it static to
fs/dcache.c. I don't think there's any possible valid use outside of
dcache.

> ObAnnoyance: gcc not figuring out that this container_of() isn't going to be
> NULL...  Sure, somebody might put (char *)16 into dentry->d_name.name, but...
> As it is, it makes for messier code generation; I can work around that, of
> course, but it's uglier than it ought to be ;-/

You could possibly play games with __attribute__((nonnull)) or
whatever it's called. Although I think you can only annotate arguments
that way (and you do it not by annotating the argument, but by making
it a function attribute, which I think is horrible, but whatever).

              Linus
