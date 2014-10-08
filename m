Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaJHPfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:35:47 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52210 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaJHPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <20141008110829.GC24908@paralelels.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org> <20141008110829.GC24908@paralelels.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Oct 2014 08:35:22 -0700
Message-ID: <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
To: Andrew Vagin <avagin@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 4:08 AM, Andrew Vagin <avagin@parallels.com> wrote:
> On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
>> Andrey Vagin <avagin@openvz.org> writes:
>>
>> > From: Andrey Vagin <avagin@gmail.com>
>> >
>> > Currently when we create a new container with a separate root,
>> > we need to clone the current mount namespace with all mounts and then
>> > clean up it by using pivot_root(). A big part of mountpoints are cloned
>> > only to be umounted.
>>
>> Is the motivation performance?  Because if that is the motivation we
>> need numbers.
>
> The major motivation to create a clean mount namespace which contains
> only required mounts.
>
> Now you want to convince us that there is nothing wrong if we use
> userns, because all inherited mounts are locked. My point is that all
> useless mounts should be umounted.  If the current root isn't on rootfs,
> pivot_root() allows us to umount all useless points. But pivot_root()
> doesn't work, if the current root is on rootfs. How can we umount
> useless points in this case?
>
> Maybe we want to say that rootfs should not be used if we are going to
> create containers...
>

Could we have an extra rootfs-like fs that is always completely empty,
doesn't allow any writes, and can sit at the bottom of container
namespace hierarchies?  If so, and if we add a new syscall that's like
pivot_root (or unshare) but prunes the hierarchy, then we could switch
to that rootfs then.

> Thanks,
> Andrew
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
