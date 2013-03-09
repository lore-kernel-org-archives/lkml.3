Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab3CICIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:08:55 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:51622 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab3CICIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130309020318.GA11449@redhat.com>
References: <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
	<20130308230734.GA28317@redhat.com>
	<CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
	<20130308233041.GA32587@redhat.com>
	<CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
	<20130308235514.GA5605@redhat.com>
	<CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
	<20130309001917.GA6015@redhat.com>
	<20130309003617.GB6743@redhat.com>
	<CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
	<20130309020318.GA11449@redhat.com>
Date: Fri, 8 Mar 2013 18:08:52 -0800
X-Google-Sender-Auth: jW5XCJ4I9LyPLoGFwCMkkVdIpAY
Message-ID: <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 6:03 PM, Dave Jones <davej@redhat.com> wrote:
>
> existing pathname + 'a' = fine.
>
> existing pathname + '/' + 'a' = boom.

Good.

> Looks like if I do this..
>
>        if (isdigit(newpath[len]) != 0) {
>                 newpath[len] = '/';
>                newpath[len+1] = 'A';
>                newpath[len+2] = 0;
>
> no bug.

Well, but that will never trigger. newpath[len] will always be NUL, so
you just disabled things entirely. Use "len-1".

So I don't think that did what you meant it to do.

            Linus
