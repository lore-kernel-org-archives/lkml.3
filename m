Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3JAHdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:33:08 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52998 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3JAHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:33:07 -0400
Date: Tue, 1 Oct 2013 09:33:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20131001073301.GA20889@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
 <52499FA5.60701@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52499FA5.60701@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> > I think Waiman's patches (even the later ones) made the queued rwlocks 
> > be a side-by-side implementation with the old rwlocks, and I think 
> > that was just being unnecessarily careful. It might be useful for 
> > testing to have a config option to switch between the two, but we 
> > might as well go all the way.
> 
> It is not actually a side-by-side implementation. A user can choose 
> either regular rwlock or the queue one, but never both by setting a 
> configuration parameter. However, I now think that maybe we should do it 
> the lockref way by pre-determining it on a per-architecture level 
> without user visible configuration option.

Well, as I pointed it out to you during review, such a Kconfig driven 
locking API choice is a no-go!

What I suggested instead: there's absolutely no problem with providing a 
better rwlock_t implementation, backed with numbers and all that.

Thanks,

	Ingo
