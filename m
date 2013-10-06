Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3JFASS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:18:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36405 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3JFASP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:18:15 -0400
Date: Sat, 05 Oct 2013 19:18:13 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <87li281wx6.fsf_-_@xmission.com> <1381014462.1974.162@driftwood>
	<CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
	<CA+55aFxgUMnZts-RXFh1qL1u+De_HNdMrC34skyWurbzvqpUdg@mail.gmail.com>
In-Reply-To: <CA+55aFxgUMnZts-RXFh1qL1u+De_HNdMrC34skyWurbzvqpUdg@mail.gmail.com>
	(from torvalds@linux-foundation.org on Sat Oct  5 18:22:15 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381018693.1974.166@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 06:22:15 PM, Linus Torvalds wrote:
> On Sat, Oct 5, 2013 at 4:17 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So learn this pattern: every time you use chroot, add a simple
> >
> >   chdir("/");
> >
> > immediately after the chroot call.
> 
> .. btw, also make sure that you close all non-essential file
> descriptors. Having any open directory file descriptors pointing to
> outside the chroot is also a classic escape.
> 
> Even then, escaping chroot is usually fairly easy. Making a
> escape-proof chroot is really quite hard. Basically impossible if you
> allow root.

Which is why containers have all sorts of extra plumbing. But that  
extra plumbing is currently built on pivot_root(), not on chroot(). And  
I'd dismissed pivot_root() as residue from initramfs with all that  
kernel thread reparenting, so it seemed like the wrong tool for the  
job, but obviously I'll take your and Al's word it's not...

Rob