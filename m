Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JEXY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:24:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3JEXYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:24:55 -0400
Date: Sun, 6 Oct 2013 00:24:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
Message-ID: <20131005232451.GX13318@ZenIV.linux.org.uk>
References: <87li281wx6.fsf_-_@xmission.com>
 <1381014462.1974.162@driftwood>
 <CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 04:17:55PM -0700, Linus Torvalds wrote:
> On Sat, Oct 5, 2013 at 4:07 PM, Rob Landley <rob@landley.net> wrote:
> >
> > A todo item I've had _forever_ is fixing chroot() to not be broken so that
> > you can trivially break out of a chroot via:
> 
> What drugs are you on?
> 
> Your example is moronic, and against all _documented_ uses of chroot.

... and even fixing that example (chroot *can* be escaped, if you can
call chroot(2) - mkdir /foo, chdir /, chroot /foo, chroot .. and you are out)
the whole thing is idiocy - chroot() is not and has never been root-proof
and anybody expecting it to be has failed to read any number of FAQs out
there.
