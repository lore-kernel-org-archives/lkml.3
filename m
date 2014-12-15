Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaLOTcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:32:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaLOTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:23 -0500
Date: Mon, 15 Dec 2014 11:32:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141215193222.GA9842@kroah.com>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183038.GA6120@kroah.com>
 <548F2A10.5070601@nod.at>
 <20141215184407.GB6761@kroah.com>
 <548F30D5.9020109@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548F30D5.9020109@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 08:04:53PM +0100, Richard Weinberger wrote:
> > Fact is, this is useful code, in this area.  In the domain it is used
> > in, it works properly, and the abi is sufficient.  Yes, it's ugly in
> > spaces, and insecure if used outside of Android, but that's ok for the
> > users of the code.
> 
> Let's discuss this while having a few beers.
> It is going to be philosophic.

I'm all for beers and philosopic talk, sounds good :)

> >> Is there a change that Android will pick it up?
> > 
> > Yes.
> 
> So then wait until this happens and ignore binder.

I have been, for years now.

But the issue is, drivers/staging/ should not just be a "dumping ground"
for code.  Code in there needs to either move forward in being cleaned
up and accepted, or it needs to be deleted.

This is the reason why I deleted the binder code from the tree a few
years ago.  Turns out, that's the first commit vendors revert when they
make an android product.  Then they add on a mis-match of patches on top
of it, bringing the code kind-of-up-to-date with the newer kernel, and
ship it.  That has caused problems by people not knowing what to apply
and fix in order to handle abi changes.

So the code went back into staging, and got fixed up, and now that's as
far as I can take it without either deleting it, or moving it out of
staging.  So I'm trying to move it out of staging.

Now I know this is a "special case" for stuff that might be "ugly".
Fact is, we are stuck with this user api due to ignoring this code for
many years on the community side, as well as Google not taking the time
and effort originally to push it upstream.  There is fault on both sides
here, I agree.

And because of that, I'm willing to maintain this on our side.  I have
confirmation that Google employees will also co-maintain it as well.
But the userspace api is something that we just have to live with, as
ugly as it is, until someone, who has the ability to commit to the
Android userspace side, does the work.

> > Since a few hundred million devices use it and we have userspace code
> > that relies on it and can't be changed?
> 
> It is news to me that these devices use a mainline kernel.

They always start with a mainline kernel, and then usually add bsp
support on top of it.  The non-bsp code in the Android tree these days
is very low.

thanks,

greg k-h
