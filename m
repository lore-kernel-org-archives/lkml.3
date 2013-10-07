Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3JGXrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:47:36 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40338 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3JGXrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
Date: Mon, 7 Oct 2013 16:47:29 -0700
X-Google-Sender-Auth: 9BZa_dtFbqn2CsZjYoqIdbIcwnA
Message-ID: <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 3:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I *think* r14 contains the function we're going to jump to in the
> oops, and that could be interesting to know, but it's not decoded, so
> you'd have to match it up against a symbol map...

Actually, Fenguguan, never mind. Instead, change the "pr_debug()" in
kobject_release() to  "pr_alert()", so that it gets printed out. Or
just boot with the "ignore_loglevel" thing so that debug messages are
actually visible.

At that point, we should be able to match the oops workqueue list
address with the address of the delayed kernel object that gets
printed out.

             Linus
