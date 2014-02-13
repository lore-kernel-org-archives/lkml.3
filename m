Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaBMShj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:37:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaBMShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:37:38 -0500
Date: Thu, 13 Feb 2014 19:37:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140213183736.GA16937@redhat.com>
References: <20140212042215.GN18016@ZenIV.linux.org.uk> <20140212054043.GB13997@dastard> <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140213174020.GA14455@redhat.com> <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com> <20140213181013.GA15596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213181013.GA15596@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13, Oleg Nesterov wrote:
>
> On 02/13, Linus Torvalds wrote:
> >
> > On Thu, Feb 13, 2014 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > And we should be careful with SIGQUEUE_PREALLOC, at least
> > > collect_signal() should not do list_del_init()... Plus we need to
> > > handle the SEND_SIG_FORCED-like case.
> >
> > I don't think the users need to care. They'd just call
> > "sigqueue_free()" not knowing about our preallocations etc.
>
> Yes, but we need to be careful to avoid the races with
> release_posix_timer().

Plus we need to delay do_schedule_next_timer() as well. But this
is probably good because we can avoid unlock/lock(siglock) in
dequeue_signal().

Oleg.

