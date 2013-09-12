Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3ILQiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:38:19 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46505 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3ILQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
Date: Thu, 12 Sep 2013 09:38:17 -0700
X-Google-Sender-Auth: 18O6osqxpQKBBNUSLG_0putqFqY
Message-ID: <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 7:55 AM, Waiman Long <Waiman.Long@hp.com> wrote:
> Change log
> ----------
> v1->v2:
>   - Rename the new seqlock primitives to read_seqexcl_lock* and
>     read_seqexcl_unlock*.

Applied. Except I peed in the snow and renamed the functions
again.That whole "seqexcl" looked too odd to me. It not only looks a
bit too much like random noise, but it makes it seem a whole different
lock from the "seqlock" thing.

I wanted to pattern the name after "write_seq[un]lock()", since it
most resembles that (not just in implementation, but in usage: the
traditional read-sequence isn't a lock, it's a begin/retry sequence,
so the usage pattern is totally different too, and the naming is
different).

I ended up picking "read_seq[un]lock_excl()". I could have gone with
"excl_" as a prefix too, I guess. Whatever. Now the "_excl" thing
looks a bit like the "_bh"/"_irqX" context modifier, and I think it
matches our normal lock naming pattern better.

            Linus
