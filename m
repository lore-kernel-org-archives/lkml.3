Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346Ab3BNXFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:05:36 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50929 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3BNXFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130213111007.GA11367@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Feb 2013 15:05:14 -0800
X-Google-Sender-Auth: tzK4ySS5dstjN-q7zpB48tLVK4U
Message-ID: <CA+55aFwpFFg+Z28aZ=92bGdU+Va00j08BzL-2frtLarKWt=qOQ@mail.gmail.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Setting up Logical Volume Management: [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1

Btw, this is an entirely unrelated thing, but it just struck me: you
have  CONFIG_DEBUG_LOCK_ALLOC in your config, so that spinlock has a
_name_, and the not-so-helpful "spin_dump()" is too stupid to even
bother to print it out.

Now, in this case, it doesn't much matter, since the callchain really
does end up showing pretty unambiguously what the lock is, but
shouldn't we print that lock name when we dump the lock information?

I dunno. Maybe the names aren't useful, and the callchain ends up
always making them redundant. But it seems an oversight in our debug
output.

                  Linus
