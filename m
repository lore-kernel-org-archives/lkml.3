Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaK0OS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:18:58 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64249 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaK0OS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:18:56 -0500
MIME-Version: 1.0
In-Reply-To: <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
Date: Thu, 27 Nov 2014 15:18:55 +0100
Message-ID: <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dario Faggioli <raistlin@linux.it>, Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 3:01 PM, Lukasz Pawelczyk
<l.pawelczyk@samsung.com> wrote:
>  extern struct dentry *securityfs_create_file(const char *name, umode_t mode,
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..5ac7fb9 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -21,8 +21,7 @@
>  #define CLONE_DETACHED         0x00400000      /* Unused, ignored */
>  #define CLONE_UNTRACED         0x00800000      /* set if the tracing process can't force CLONE_PTRACE on this clone */
>  #define CLONE_CHILD_SETTID     0x01000000      /* set the TID in the child */
> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> -   and is now available for re-use. */
> +#define CLONE_NEWLSM           0x02000000      /* New LSM namespace */

FYI, CLONE_NEWCGROUP also claims last flag [1].

As it looks we will get more and more namespaces, more than clone() can handle.

[1] https://lkml.org/lkml/2014/7/17/588

-- 
Thanks,
//richard
