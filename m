Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaJGWTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:19:36 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:60872 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaJGWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <87zjd7r1z9.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org> <20141007204627.GI28519@ubuntumail>
 <87wq8bvbzg.fsf@x220.int.ebiederm.org> <20141007213257.GJ28519@ubuntumail> <87zjd7r1z9.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 15:19:12 -0700
Message-ID: <CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> I am squinting and looking this way and that but while I can imagine
> someone more clever than I can think up some unique property of rootfs
> that makes it a little more exploitable than just mounting a ramfs,
> but since you have to be root to exploit those properties I think the
> game is pretty much lost.

Yes.  rootfs might not be empty, it might have totally insane
permissions, and it's globally shared, which makes it into a wonderful
channel to pass things around that shouldn't be passed around.

Can non-root do this?  You'd need to be in a userns with a "/" that
isn't MNT_LOCKED.  Can this happen on any normal setup?

FWIW, I think we should unconditionally MNT_LOCKED the root on userns
unshare, even if it's the only mount.


>
>>> >> So it is only root (and not root in a container) who can get to the
>>> >> exposed rootfs.
>>> >>
>>> >> I have a vague memory someone actually had a real use in miminal systems
>>> >> for being able to get back to the rootfs and being able to use rootfs as
>>> >> the rootfs.  There was even a patch at that time that Andrew Morton was
>>> >> carrying for a time to allow unmounting root and get at rootfs, and to
>>> >> prevent the oops on rootfs unmount in some way.
>>> >>
>>> >> So not only do I not think it is a bug to get back too rootfs, I think
>>> >> it is a feature that some people have expressed at least half-way sane
>>> >> uses for.
>>> >
>>> > They can still do that if they want, using chroot :)
>>>
>>> It would take fchdir or fchroot and a directory file descriptor open on
>>> rootfs.  Frequently there is no appropriate directory file descriptor.
>>
>> ?  you can always escape if you're simply chrooted.  waterbuffalo :)
>
> filesystem type rootfs.
>
> Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
