Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3JJL5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:57:20 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34849 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3JJL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:57:16 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <87vc15mjuw.fsf@xmission.com>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com>
	<87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	<87vc15mjuw.fsf@xmission.com>
Date: Thu, 10 Oct 2013 13:57:15 +0200
Message-ID: <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the
 current mount namespace
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 1:43 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:

> I have been weighing the pros and the cons of this.
>
> At this point the most practical path I can see is to block unlink,
> rename, and rmdir if there is a mount in the local namespace.
>
> At the very least that makes very limited additions to what applications
> can depend on from the vfs, and even more importantly that can be ready
> by 3.13.
>
> Furthermore it removes the nasty need for filesystems to lie to the vfs,
> and removes the nasty DOS that non-local mountpoints are.

Agreed 100%.

> Miklos if you as the fuse maintainer aren't worried about network
> filesystems, and multiple namespaces I won't worry either.  Especially
> since modern versions of fuse aren't affected.

I think the above conditions (local mount blocks unlink/rename) are
enough to prevent most of the problems, of which there aren't many in
any case.

Thanks,
Miklos
