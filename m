Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaBQRqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaBQRqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:46:54 -0500
Date: Mon, 17 Feb 2014 18:46:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140217174648.GA6176@redhat.com>
References: <20140215052531.GX18016@ZenIV.linux.org.uk> <20140215142700.GA15540@redhat.com> <20140215152251.GY18016@ZenIV.linux.org.uk> <20140215153631.GZ18016@ZenIV.linux.org.uk> <20140215155838.GA18016@ZenIV.linux.org.uk> <20140215174345.GA24799@redhat.com> <20140215180520.GC18016@ZenIV.linux.org.uk> <20140215184531.GA27314@redhat.com> <20140217165735.GA29173@redhat.com> <20140217174059.GD18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217174059.GD18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Al Viro wrote:
>
> On Mon, Feb 17, 2014 at 05:57:35PM +0100, Oleg Nesterov wrote:
>
> > Looks like, this is all is really nasty. Actually, I think siginfo on
> > stack is not that bad if we are going to do handle_signal() or restart,
> > perhaps we can do the extra kmalloc/memcpy/kfree for do_coredump().
> > Something like below.
>
> Yecchhhh...  You've just broken every architecture other than x86,

Of course, this is only to explain what I meant.

> and to
> fix them you'll need to massage every get_signal()/get_signal_to_deliver()
> user out there,

Yes.

> pulling the logics *out* of kernel/signal.c and into arch/*.

Not really, I think. Of course this change should be cleanuped. And it
should not require to change all architectures at once.

> This is just plain wrong.

I agree, this change is also ugly.

Oleg.

