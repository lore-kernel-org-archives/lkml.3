Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3CVBdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:33:37 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:48394 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CVBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130322012208.GJ21522@ZenIV.linux.org.uk>
References: <20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 18:33:35 -0700
X-Google-Sender-Auth: _sr8YvtWC_8w-n6_90cfS1jEwgo
Message-ID: <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 6:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> In theory, we can make vfs_rmdir() and vfs_unlink() check the presense of
> the corresponding method before locking the victim; that would suffice to
> kludge around that mess on procfs.  Along with ->d_inode comparison in
> lock_rename() it *might* suffice.

Hmm, yes. Maybe we can do that as a stopgap, backport that, and leave
any bigger changes for the development tree. That would make the issue
less urgent, never mind all the other worries about backporting
complicated patches for subtle issues.

I realize you aren't entirely thrilled about it, but we actually
already seem to do that check in both vfs_rmdir().and vfs_unlink()
before getting the child i_mutex.  I wonder if that is because we've
already seen lockdep splats for this case...

                 Linus
