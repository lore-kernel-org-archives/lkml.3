Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBMRkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:40:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaBMRkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:40:21 -0500
Date: Thu, 13 Feb 2014 18:40:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140213174020.GA14455@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk> <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com> <20140212040358.GA25327@redhat.com> <20140212042215.GN18016@ZenIV.linux.org.uk> <20140212054043.GB13997@dastard> <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12, Linus Torvalds wrote:
>
> On Wed, Feb 12, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...  What if we delay __sigqueue_free()?  After all, that's where the
> > fat sucker normally comes from.  That way we might get away with much
> > smaller structure on stack...
>
> Sounds like the RightThing(tm) to do to me, and I don't see why it
> wouldn't work.

Probably... I'll try to reply tomorrow.

> We'd have to teach each user of "dequeue_signal()" to free the siginfo
> thing.

And we should be careful with SIGQUEUE_PREALLOC, at least
collect_signal() should not do list_del_init()... Plus we need to
handle the SEND_SIG_FORCED-like case.

Oleg.

