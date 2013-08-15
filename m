Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3HOJ3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:29:07 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52199 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3HOJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:29:04 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
Date: Thu, 15 Aug 2013 11:29:01 +0200
Message-ID: <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
Subject: Re: DoS with unprivileged mounts
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 8:45 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Part of me does prefer the semantics Andy has suggested where instead of
> unmounting things we have something like a skeleton of the mount tree
> unioned with dcaches of the filesystems themselves.  With "struct
> mountpoint" we are amazing close to that already.
>
> A mount skeleton would allow us to always remove and rename directories
> and files without really caring, about what mounts were present.
> Probably with just a quick lookup to see if we need to set
> DCACHE_MOUNTED.

Yes, we could have a separate dentry tree just for anchoring mounts
and we could make a union with the real dentry tree.  But implementing
that in a low overhead manner is not trivial.  Anchoring mounts on
real dentries is *rather* convenient.   And yes, we only actually need
the skeleton dentries when the real ones disappear, but that doesn't
make the implementation any simpler.

> The big practical problem I can see with MNT_VOLATILE is mount points in
> shared directories like /tmp but without the sticky set.  At which point
> it would be possible to delete another users mount points.  Perhaps we
> need restrictions on where a user can mount.

I think if user X mounts something on /tmp/foo owned by user Y and
user Y removes /tmp/foo then that shouldn't really surprise user X.  I
don't see this an issue.

Thanks,
Miklos
