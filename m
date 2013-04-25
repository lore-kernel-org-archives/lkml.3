Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3DYHsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:48:05 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:50917 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DYHsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
References: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
Date: Thu, 25 Apr 2013 09:48:00 +0200
Message-ID: <CAFLxGvy33QyJEMu_z47oyEEMY_awpT5rkoP4DYVjBQjsZysaGA@mail.gmail.com>
Subject: Re: For review (v2): user_namespaces(7) man page
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Rob Landley <rob@landley.net>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, luto@amacapital.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:26 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
>        Inside the user namespace, the shell has user and group  ID  0,
>        and a full set of permitted and effective capabilities:
>
>            bash$ cat /proc/$$/status | egrep '^[UG]id'
>            Uid: 0    0    0    0
>            Gid: 0    0    0    0
>            bash$ cat /proc/$$/status | egrep '^Cap(Prm|Inh|Eff)'
>            CapInh:   0000000000000000
>            CapPrm:   0000001fffffffff
>            CapEff:   0000001fffffffff

I've tried your demo program, but inside the new ns I'm automatically nobody.
As Eric said, setuid(0)/setgid(0) are missing.

Eric, maybe you can help me. How can I drop capabilities within a user
namespace?
In childFunc() I did add prctl(PR_CAPBSET_DROP, CAP_NET_ADMIN) but it always
returns ENOPERM.
What that? I thought I get a completely fresh set of cap which I can modify.
I don't want that uid 0 inside the container has all caps.

And why does /proc/*/loginuid always contain 4294967295 in a new user namespace?
Writing to it also fails. (Noticed that because pam_loginuid.so does not work).

Final question, is it by design that uid 0 within a namespace in not
allowed to write to
/proc/*/oom_score_adj?


Thanks,
//richard

P.s: I've used 3.9-rc8 for my tests...
