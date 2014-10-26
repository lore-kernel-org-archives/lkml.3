Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJZXdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:33:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63925 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaJZXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141026215742.GT7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
	<87siibttyi.fsf@x220.int.ebiederm.org>
	<20141026030608.GN7996@ZenIV.linux.org.uk>
	<20141026035100.GO7996@ZenIV.linux.org.uk>
	<20141026035705.GP7996@ZenIV.linux.org.uk>
	<CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
	<20141026191332.GS7996@ZenIV.linux.org.uk>
	<20141026215742.GT7996@ZenIV.linux.org.uk>
Date: Sun, 26 Oct 2014 16:33:11 -0700
X-Google-Sender-Auth: OKBqB6_PQdZ8QY5TD-bZauVeqc8
Message-ID: <CA+55aFxfDgYsp9SAxWTy2sS0KLrErPUd06bEYJf=siCmaBu52w@mail.gmail.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 2:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>  .. snip ..
> in d_walk(), __list_del() instead of list_del() in __dentry_kill(), d_u.d_child
> turning into d_child everywhere, while d_alias turns into d_u.d_alias...
>
> It looks like that way we would get no retries on the second pass.  Comments?

Since I missed the whole issue with d_child.next, I'm not sure any
comments from me would be helpful.

It does sound like trying to be more careful with d_child and using
d_alias instead is a good idea. d_alias is only used under the dentry
lock, and not in any horribly subtle situations, right? So that sounds
like a good change regardless of this particular fix - making the
union happen in a less nasty place..

                     Linus
