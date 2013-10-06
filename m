Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3JFAWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:22:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38561 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3JFAWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:22:02 -0400
Date: Sat, 05 Oct 2013 19:22:00 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <87li281wx6.fsf_-_@xmission.com> <1381014462.1974.162@driftwood>
	<CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
	<20131005232451.GX13318@ZenIV.linux.org.uk>
In-Reply-To: <20131005232451.GX13318@ZenIV.linux.org.uk> (from
	viro@ZenIV.linux.org.uk on Sat Oct  5 18:24:51 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381018920.1974.167@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 06:24:51 PM, Al Viro wrote:
> On Sat, Oct 05, 2013 at 04:17:55PM -0700, Linus Torvalds wrote:
> > On Sat, Oct 5, 2013 at 4:07 PM, Rob Landley <rob@landley.net> wrote:
> > >
> > > A todo item I've had _forever_ is fixing chroot() to not be  
> broken so that
> > > you can trivially break out of a chroot via:
> >
> > What drugs are you on?
> >
> > Your example is moronic, and against all _documented_ uses of  
> chroot.
> 
> ... and even fixing that example (chroot *can* be escaped, if you can
> call chroot(2) - mkdir /foo, chdir /, chroot /foo, chroot .. and you  
> are out)

Um, wasn't that my example?

> the whole thing is idiocy - chroot() is not and has never been  
> root-proof
> and anybody expecting it to be has failed to read any number of FAQs  
> out
> there.

Which is why I was proposing modifying it so lxc and containers didn't  
have to use pivot_root() instead, with all the logic to rehome existing  
processes and the weird "this path is relative the old root, this path  
is relative to the new root" syntax from initial ramdisks.

Rob