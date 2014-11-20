Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbaKTSSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:18:32 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39690 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbaKTSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <87egsxnbth.fsf@x220.int.ebiederm.org>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
 <87egsxnbth.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Nov 2014 10:18:08 -0800
Message-ID: <CALCETrXxqcJd9=9c+HNMYmO5V+pV+EpjTA0NVvC6peGv_CyWuQ@mail.gmail.com>
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system calls
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-man <linux-man@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2014 7:16 AM, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
> Josh Triplett <josh@joshtriplett.org> writes:
>
> > Analogous to the supplementary GID list, the supplementary UID list
> > provides a set of additional user credentials that a process can act as.
> > A process with CAP_SETUID can set its UID list arbitrarily; a process
> > without CAP_SETUID can only reduce its UID list.
> >
> > This allows each user to have a set of UIDs that they can then use to
> > further sandbox individual child processes without first escalating to
> > root to change UIDs.  For instance, a PAM module could give each user a
> > block of UIDs to work with.
>
> A couple of quick comments on this patch.
>
> 1) user namespaces already allow you to do this.

I thought you could only map your fsuid. Can you set fsuid to a
supplementary group?

>
> 2) After having looked at the group case I am afraid this intersects in
>    an unfortunate way with user namespaces.
>
> 3) This intersects in a very unfortunate way with setresuid.
>    Applications that today know they are dropping all privileges
>    won't be dropping all privielges with this change.  Which sounds like
>    a recipe for a security exploit to me.
>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
