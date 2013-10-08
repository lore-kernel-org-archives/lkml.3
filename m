Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3JHIDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab3JHIDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:03:15 -0400
Date: Tue, 8 Oct 2013 10:03:03 +0200
From: Karel Zak <kzak@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
Message-ID: <20131008080303.GH14360@x2.net.home>
References: <8761tctwhg.fsf@xmission.com>
 <1381016564.1974.163@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381016564.1974.163@driftwood>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 06:42:44PM -0500, Rob Landley wrote:
> Oh, attached is a dumb "zapchroot" script I've been using for years to
> unlink all mount points under a given directory, taking advantage of the
> fact that mount points are appended to the end of the list so if you unlink
> from the end to the front you should get the sub-mounts before the parent
> mounts (modulo mount --move not reordering the list, but that's uncommon).

 util-linux umount supports --recursive, it uses /proc/self/mountinfo
 to compose the hierarchy. The important is that the mountinfo file
 contains Id and Parent_Id relations, so you don't rely on the order
 only.

> Recently I noticed some kernels where chroot does _not_ trim the paths so
> that the paths you see in /proc/mounts are relevant to the current chroot
> but instead have all sorts of crap you can't access with no way to know what
> it's talking about. That was sad, I need to go figure out if that was distro
> breakage or vanilla breakage...

 hmm..

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
