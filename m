Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3JHKs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:48:28 -0400
Received: from awesome.dsw2k3.info ([217.188.63.246]:45424 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882Ab3JHKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:48:25 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 06:48:25 EDT
Date: Tue, 8 Oct 2013 12:42:02 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but
 the current mount namespace
Message-ID: <20131008104202.GA20639@citd.de>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87a9ioo37a.fsf_-_@xmission.com>
 <20131007043919.GB10284@mail.hallyn.com>
 <87vc191sf2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc191sf2.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.2013 23:55, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> So if we can feel safe just depending on the parent directory
> permissions (which are not hidden by a mount) protecting our mount
> points, I feel much better about this patchset.

As far as i can tell, the permissions of the host-directory of a 
mount-point are hidden, at least for user-space.
(Ignoring (bind-)mounting the parent-mount somewhere else)

As root:
$ mkdir /tmp/test
$ ls -ld /tmp/test
drwxr-xr-x 2 root root 40 Oct  8 12:33 /tmp/test

$ mount tmpfs -t tmpfs /tmp/test
$ ls -ld /tmp/test
drwxrwxrwt 2 root root 40 Oct  8 12:33 /tmp/test

$ chown nobody.users /tmp/test
$ ls -ld /tmp/test
drwxrwxrwt 2 nobody users 40 Oct  8 12:33 /tmp/test

$ umount /tmp/test
$ ls -ld /tmp/test
drwxr-xr-x 2 root root 40 Oct  8 12:33 /tmp/test


So if the kernel would check the host-directory-permissions for allowing 
umounting by rmdir it follows that a "plain user" doesn't have any 
possibility to know beforehand if rmdir/umount would be possible.



-- 

Matthias
