Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaLHWXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:23:10 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63249 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaLHWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141208221401.GA4991@thunk.org>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
	<20141208164650.GB29028@node.dhcp.inet.fi>
	<20141208175805.GB22149@ZenIV.linux.org.uk>
	<20141208185635.GA25867@node.dhcp.inet.fi>
	<CA+55aFwow9hVqNVGp7gjnnu4=A+J8vw1i22W4e7+1r1-215cHg@mail.gmail.com>
	<20141208192358.GB25867@node.dhcp.inet.fi>
	<20141208221401.GA4991@thunk.org>
Date: Mon, 8 Dec 2014 14:23:06 -0800
X-Google-Sender-Auth: eoCo4pFy6oVinMy7XnM2r285ksU
Message-ID: <CA+55aFz26Xvfs4iePpGgJotw+uwFCKduGqyM57adgfGepQYp_w@mail.gmail.com>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 2:14 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> running trinity as root should be quite safe in a VM.  :-)

It's not so much the safety that I'd worry about, it's the "you can
legitimately just reboot it or cause kernel corruption as root". You
may not cause any problems outside of the VM, but any oopses inside
the VM might be due to trinity just doing bad things as root, rather
than kernel bugs..

Of course, it's probably hard to hit things like laoding random
modules etc, since even without signature requirements there are tons
of ELF sanity checks and other things. So it might be hard to actually
do those kinds of "corrupt kernel memory as root" things with trinity.

                 Linus
