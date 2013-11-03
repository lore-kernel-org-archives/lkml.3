Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3KCXjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 18:39:18 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56570 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3KCXjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 18:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <20131103195452.GL13318@ZenIV.linux.org.uk>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
	<CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
	<20131103195452.GL13318@ZenIV.linux.org.uk>
Date: Sun, 3 Nov 2013 15:39:14 -0800
X-Google-Sender-Auth: dRiTWT9cu8ryDI8bEYL3V-y0xJQ
Message-ID: <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
Subject: Re: [git pull] fixes for 3.12-final
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bruce Fields <bfields@fieldses.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 11:54 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> IIRC, at some point such an attempt has seriously hurt iget() on 32bit
> boxen, so we ended up deciding not to go there.  Had been years ago,
> though...

Yeah, I think the circumstances have changed. 32-bit is less
important, and iget() is much less critical than it used to be (all
*normal* inode lookups are through the direct dentry pointer).

Sure, ARM is a few years away from 64-bit being common, but it's
happening. And I suspect even 32-bit ARM doesn't have the annoying
issues that x86-32 had with 64-bit values (namely using up a lot of
the register space).

So unless there's something hidden that makes it really nasty, I do
suspect that a "u64 i_ino" would just be the right thing to do. Rather
than adding workarounds for our current odd situation on 32-bit
kernels (and just wasting time on 64-bit kernels).

          Linus
