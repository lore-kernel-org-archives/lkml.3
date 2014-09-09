Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaIIT1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:27:21 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61509 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaIIT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:27:19 -0400
MIME-Version: 1.0
In-Reply-To: <87ppf4n5ib.fsf@x220.int.ebiederm.org>
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com>
 <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 9 Sep 2014 12:26:57 -0700
Message-ID: <CALCETrV4WizRXD9JuwibUBbQE9hhNrRDJ3cYyXdhd=OfPziF5g@mail.gmail.com>
Subject: Re: For review: user_namespace(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 9:05 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> We may also want to discuss the specific restrictions on chroot.
>
> The text about chroot at least gives people a strong hint that the
> chroot rules are affected by user namespaces.
>
> The restrictions that we have settled on to avoid chroot being a problem
> are the creator of a user namespace must not be chrooted in their
> current mount namespace, and the creator of the user namespace must not
> be threaded.
>
> Andy can you check me on this it looks like unshare is currently buggy
> in that it will allow a threaded application to create a user namespace.

I think it's this code in unshare:

    /*
     * If unsharing a user namespace must also unshare the thread.
     */
    if (unshare_flags & CLONE_NEWUSER)
        unshare_flags |= CLONE_THREAD | CLONE_FS;

I suppose that this should be documented.

CLONE_FS prevents the chroot from leaking out of the namespace.  (But
see the other thread that I'm about to start...)

--Andy
