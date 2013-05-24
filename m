Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3EXDkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:40:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57404 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883Ab3EXDkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:40:20 -0400
MIME-Version: 1.0
Date: Fri, 24 May 2013 13:40:19 +1000
Message-ID: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
Subject: BUG_ON in virtio-ring.c
From: Dave Airlie <airlied@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

current virtio-ring.c has a BUG_ON in virtqueue_add that checks
total_sg > vg->vring.num, however I'm not sure it really is 100%
correct.

If I have an indirect ring and I'm adding sgs to it and the host is
delayed (say I've got a thread consuming things from the vring and its
off doing something interesting),
I'd really like to get ENOSPC back from virtqueue_add. However if the
indirect addition fails due to free_sg being 0, we hit the BUG_ON
before we ever get to the ENOSPC check.

the BUG_ON is quite valid in the no indirect case, but when we have
indirect buffers it doesn't seem like it always makes sense.

Not sure best way to fix it, I'm just a virtio newbie :)

Dave.
