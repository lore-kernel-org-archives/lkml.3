Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3E0D3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 23:29:53 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:64518 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3E0D3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 23:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <87vc65p5a7.fsf@rustcorp.com.au>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
	<87vc65p5a7.fsf@rustcorp.com.au>
Date: Mon, 27 May 2013 13:29:50 +1000
Message-ID: <CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com>
Subject: Re: BUG_ON in virtio-ring.c
From: Dave Airlie <airlied@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> correct.
>>
>> If I have an indirect ring and I'm adding sgs to it and the host is
>> delayed (say I've got a thread consuming things from the vring and its
>> off doing something interesting),
>> I'd really like to get ENOSPC back from virtqueue_add. However if the
>> indirect addition fails due to free_sg being 0, we hit the BUG_ON
>> before we ever get to the ENOSPC check.
>
> It is correct for the moment: drivers can't assume indirect buffer
> support in the transport.
>
> BUT for a new device, we could say "this depends on indirect descriptor
> support", put the appropriate check in the device init, and then remove
> the BUG_ON().

But if the transport has indirect buffer support, can it change its
mind at runtime?

In this case we have vq->indirect set, but the device has run out of
free buffers,
but it isn't a case that in+out would overflow it if it had free
buffers since it would use
an indirect and succeed.

Getting -ENOSPC is definitely what should happen from what I can see,
not a BUG_ON,
I should get a BUG_ON only if the device reports no indirect support.

Dave.
