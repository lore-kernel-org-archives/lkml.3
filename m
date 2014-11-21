Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaKUSir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:38:47 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48251 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKUSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:38:45 -0500
MIME-Version: 1.0
In-Reply-To: <87ppcgju9w.fsf@x220.int.ebiederm.org>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk> <87mw7xd9zt.fsf@x220.int.ebiederm.org>
 <20141112130915.GG333@tucsk> <20141112162254.GB31775@ubuntu-hedt>
 <20141118152156.GA21726@ubuntu-mba51> <CAJfpeguuT1V1Pf0iFXRozmeohDH2Jy=p8o=1EnvD_qfB1CTQuA@mail.gmail.com>
 <CAJfpeguctYFkzBPN26=WjOCLTt2mqvouHXqLZ1sRqZngtbw8CQ@mail.gmail.com>
 <20141119140911.GA27009@mail.hallyn.com> <20141121164441.GA1730@ubuntu-mba51> <87ppcgju9w.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 10:38:23 -0800
Message-ID: <CALCETrU_Ap-cENF4nczn1FrtRxKfWBT0TdHN0cU4rJt=Nvxpgw@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:14 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> - Tweak the file capability code to look at s_user_ns and treat it
>   properly.
>

> - Tweak the security checks to allow setting file capabilities and
>   other security xattrs if we have the appropriate capabilities in
>   s_user_ns.
>

Thinking about this some more, what do you mean by tweaking the file
capability code to look at s_user_ns and treat it properly?

I think that the semantics should be that cap_inode_setxattr should
check ns_capable wrt s_user_ns, but that the fscap *consumer* should
check the mount as in my may_suid patch (and maybe also check
s_user_ns).  There is legacy code that starts a FUSE server as global
root, mounts the thing in a mount namespace belonging to an
unprivileged user ns, and (I think) hands the /dev/fuse fd to that
unprivileged code.

Without the mount ns check, that FUSE server can take over the system.
With the mount ns check, it's safe.

--Andy

>
> When those bits are done we can tweak the fuse patches to also set
> s_user_ns.
>
> As for MNT_NO_SUID if fuse wants to enforce that in some way.  I don't
> particularly care, but I don't think that makes sense as a vfs property.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
