Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3E0CqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:46:00 -0400
Received: from ozlabs.org ([203.10.76.45]:57041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab3E0Cp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:45:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Cc: <virtualization@lists.linux-foundation.org>
Subject: Re: BUG_ON in virtio-ring.c
In-Reply-To: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 27 May 2013 11:12:24 +0930
Message-ID: <87vc65p5a7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:
> Hi Rusty,
>
> current virtio-ring.c has a BUG_ON in virtqueue_add that checks
> total_sg > vg->vring.num, however I'm not sure it really is 100%
> correct.
>
> If I have an indirect ring and I'm adding sgs to it and the host is
> delayed (say I've got a thread consuming things from the vring and its
> off doing something interesting),
> I'd really like to get ENOSPC back from virtqueue_add. However if the
> indirect addition fails due to free_sg being 0, we hit the BUG_ON
> before we ever get to the ENOSPC check.

It is correct for the moment: drivers can't assume indirect buffer
support in the transport.

BUT for a new device, we could say "this depends on indirect descriptor
support", put the appropriate check in the device init, and then remove
the BUG_ON().

> the BUG_ON is quite valid in the no indirect case, but when we have
> indirect buffers it doesn't seem like it always makes sense.
>
> Not sure best way to fix it, I'm just a virtio newbie :)

Mailing me and the list was the right thing, since this raises question
of the spec as well as the Linux implementation.

Good luck!
Rusty.
