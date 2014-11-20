Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaKTTMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbaKTTMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:12:35 -0500
Message-ID: <1416510751.3116.13.camel@localhost>
Subject: Re: sparc: Clashing values for O_PATH and FMODE_NONOTIFY?
From: Eric Paris <eparis@redhat.com>
To: David Drysdale <drysdale@google.com>
Cc: David Miller <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2014 14:12:31 -0500
In-Reply-To: <CAHse=S-f5o3vbT+b1D5baEWCWMUnDyLSxM88+vwwymFuLrTirg@mail.gmail.com>
References: <CAHse=S_EY3mJ_pdZf+A46joro_uNy=6tXGG1v7Va4NX_YxJu2w@mail.gmail.com>
	 <20141119.153001.1273476178846053821.davem@davemloft.net>
	 <CAHse=S-f5o3vbT+b1D5baEWCWMUnDyLSxM88+vwwymFuLrTirg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 12:12 +0000, David Drysdale wrote:
> [+linux-fsdevel, without the typo this time]
> 
> On Wed, Nov 19, 2014 at 8:30 PM, David Miller <davem@davemloft.net> wrote:
> > From: David Drysdale <drysdale@google.com>
> > Date: Tue, 18 Nov 2014 13:13:51 +0000
> >
> >> Hi folks,
> >>
> >> It looks like the value for O_PATH on sparc:
> >>
> >>   arch/sparc/include/uapi/asm/fcntl.h:37:#define O_PATH 0x1000000
> >>
> >> clashes with the arch-independent value for __FMODE_NONOTIFY:
> >>
> >>   include/linux/fs.h:137:#define FMODE_NONOTIFY ((__force fmode_t)0x1000000)
> >>   include/linux/fs.h:2764:#define __FMODE_NONOTIFY ((__force int)
> >> FMODE_NONOTIFY)
> >>
> >> and they are both in the same numbering space, as indicated by the
> >> comment at the top of include/uapi/asm-generic/fcntl.h and the use in
> >> fs/notify/fanotify/fanotify_user.c:715.
> >>
> >> Presumably this could theoretically cause problems (no notifications for
> >> O_PATH files on SPARC?), so would it be a good idea to renumber
> >> FMODE_NONOTIFY?  (I *think* that value is entirely kernel-internal.)
> >>
> >> Given that this has happened before (12ed2e36c98aec6c4155 "fanotify:
> >> FMODE_NONOTIFY and __O_SYNC in sparc conflict") it would probably
> >> also be a good idea to add __FMODE_NOTIFY to the uniqueness check in
> >> fs/fcntl.c:fcntl_init().
> >>
> >> Thoughts?
> >
> > I think you will need to change the internal value, to not clash with
> > the sparc exported one, for sure.
> 
> Well, I was sort of hoping someone else might volunteer to make the
> change :-) --  I don't use fanotify (or sparc for that matter), I just
> happened to notice the clash in passing.
> 
> But I'm happy to have a go, although I can't test much.  It would be
> good to hear from the fanotify maintainers first, though -- Eric?

It's totally internal.  And was picked to not clash with anyone.  I
don't know how to keep it from happening in the future.....

