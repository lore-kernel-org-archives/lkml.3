Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3BQUCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 15:02:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab3BQUCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 15:02:44 -0500
Date: Sun, 17 Feb 2013 21:01:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
Message-ID: <20130217200103.GC22544@redhat.com>
References: <20130217191819.GA21778@redhat.com> <CA+55aFx-9Ajb13JfxghNMzoHMJWDtH=a0DZfz2Q-eCBnHyVDPQ@mail.gmail.com> <20130217195044.GA22544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217195044.GA22544@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Oleg Nesterov wrote:
>
> On 02/17, Linus Torvalds wrote:
> >
> > SIGKILL really is very very special. Having it kill a
> > coredump in progress sounds fine to me.
>
> Great.

Forgot to mention just in case...

We could probably make a simpler patch. do_coredump() can ignore
all signals except SIGKILL from the start. But when I suggested
this change in the past I was told that the dump handler looks
(or may look) at /proc/pid/status so we shouldn't do this.

And instead of s/SIGNAL_GROUP_EXIT/group_exit_task/ in 2/3 we
could add the ugly but simple checks in __send_signal() paths.
Say we could rely on PF_DUMPCORE (which btw asks for cleanup
anyway).

However, I think that using ->group_exit_task is better (if
correct!) and simply more logical.

Oleg.

