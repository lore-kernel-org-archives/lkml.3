Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaE1UZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:25:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaE1UZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:25:08 -0400
Date: Wed, 28 May 2014 21:25:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528202505.GC18016@ZenIV.linux.org.uk>
References: <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
 <CA+55aFy6-bga8LumLKO8Yc_83vA=p-g8sqUE-aGP-uF3Xb6e4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy6-bga8LumLKO8Yc_83vA=p-g8sqUE-aGP-uF3Xb6e4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:02:23PM -0700, Linus Torvalds wrote:

> Anyway, one reason I looked at this is that most of the threads in
> Mika's NMI watchdog traces were stuck on _raw_spin_lock() in the whole
> d_walk() thing, and I had a *really* hard time convincing myself that
> this was all safe without the RCU lock. I'm wondering if Mika perhaps
> has CONFIG_PREEMPT_RCU set, which means that spinlocks (or the
> rename_lock sequence lock) do not end up being RCU-safe points.

d_walk() covers its arse with ->d_lock (and it wants the starting point
to be pinned, obviously).  So AFAICS RCU is not a problem.
