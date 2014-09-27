Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaI0Thk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:37:40 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61527 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaI0Thi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140927191657.GU7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
Date: Sat, 27 Sep 2014 12:37:36 -0700
X-Google-Sender-Auth: uOFhJtpUmc2BTDQiunl00OJN5bU
Message-ID: <CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 12:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, I suspect that the right approach is to put refcount + rcu_head in
> front of external name and do the following:

That's actually fancier than I was expecting. I was just thinking
doing a whole new allocation and freeing the old one using RCU. But I
guess you're right, you do need the rcu_head even for that, and once
you start adding fields you might as well just add a refcount too, and
then you don't have the annoyance of a potential memory allocation in
that code.

So your approach is better and doesn't sound too painful at all.

But yeah, I guess we can/should do the trivial ugly thing for 3.17.
Send me a proper pull-request,

                  Linus
