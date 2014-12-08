Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaLHWM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:12:59 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50351 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaLHWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:12:56 -0500
MIME-Version: 1.0
In-Reply-To: <87y4qhpzfj.fsf_-_@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87y4qhpzfj.fsf_-_@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 8 Dec 2014 14:12:34 -0800
Message-ID: <CALCETrUR2F+EoiOxO56Z0Fr3BZre3-0hQrORjjk9pa-JPZPodA@mail.gmail.com>
Subject: Re: [CFT][PATCH 4/7] userns: Check euid no fsuid when establishing an
 unprivileged uid mapping
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 2:08 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> setresuid allows the euid to be set to any of uid, euid, suid, and
> fsuid.  Therefor it is safe to allow an unprivileged user to map their
> euid and use CAP_SETUID privileged with exactly that uid, as no new
> credentials can be obtained.
>
> I can not find a combination of existing system calls that allows
> setting uid, euid, suid, and fsuid from the fsuid making the previous
> use of fsuid for allowing unprivileged mappings a bug.

Right.

>
> This is part of a fix for CVE-2014-8989.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 8e7c87162171..da1eeb927b21 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -819,7 +819,7 @@ static bool new_idmap_permitted(const struct file *file,
>                 u32 id = new_map->extent[0].lower_first;
>                 if (cap_setid == CAP_SETUID) {
>                         kuid_t uid = make_kuid(ns->parent, id);
> -                       if (uid_eq(uid, file->f_cred->fsuid))
> +                       if (uid_eq(uid, file->f_cred->euid))
>                                 return true;
>                 }
>         }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
