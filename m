Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab3CIBSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:18:33 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:43826 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab3CIBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130309003617.GB6743@redhat.com>
References: <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
	<20130308210432.GA21500@redhat.com>
	<CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
	<20130308230734.GA28317@redhat.com>
	<CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
	<20130308233041.GA32587@redhat.com>
	<CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
	<20130308235514.GA5605@redhat.com>
	<CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
	<20130309001917.GA6015@redhat.com>
	<20130309003617.GB6743@redhat.com>
Date: Fri, 8 Mar 2013 17:18:29 -0800
X-Google-Sender-Auth: DFDWHwydcMXqD1ojvHU1P9l9IGc
Message-ID: <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
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

On Fri, Mar 8, 2013 at 4:36 PM, Dave Jones <davej@redhat.com> wrote:
>
> Ok, it's definitly the 'append something on the end of a valid pathname'
> changeset. 'something' can be anything it seems.

Ok. so maybe the way to "bisect" this is to play with that.

For example, does it happen even if the "something" does not have a
slash in it? IOW, you just append, say, a single 'a' character to a
name that doesn't already end in a slash?

And if it still does happen with that, perhaps you could have some
logic that only appends the 'a' to names that end with numbers. Does
it stop happening?

The machine keeps running, right? So you can try this out without
rebooting, just changing when you append the character?

               Linus
