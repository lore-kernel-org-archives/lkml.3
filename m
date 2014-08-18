Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaHRQdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:33:44 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:49979 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaHRQdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140818161624.7176991f@notabene.brown>
References: <20140818161624.7176991f@notabene.brown>
Date: Mon, 18 Aug 2014 09:33:41 -0700
Message-ID: <CAPcyv4jQ0F0F1+J+=+9DivM4X0pO+KH+mug6DvvQ3advt1m9yg@mail.gmail.com>
Subject: Re: ALERT: md/raid6 data corruption risk.
From: Dan Williams <dan.j.williams@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Manibalan P <pmanibalan@amiindia.co.in>,
        Yuri Tikhonov <yur@emcraft.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 11:16 PM, NeilBrown <neilb@suse.de> wrote:
>
> Hi all,
>  There is a risk of data loss with md/raid6 arrays running on Linux since
>  2.6.32.
>  If:
>    - the array is doubly degraded
>    - one or both failed devices are being recovered, and
>    - the array is written to
>
>  then it is possible for data on the array to be lost.  The patch below fixes
>  the problem.  If you apply the patch to an older kernel which has separate
>  handle_stripe5() and handle_stripe6() functions, be sure that patch changes
>  handle_stripe6().
>
>  There is no risk to an optimal array or a singly-degraded array.  There is
>  also no risk on a doubly-degraded array which is not recovering a device or
>  is not receiving write requests.
>
>  If you have data on a RAID6 array, please consider how to avoid corruption,
>  possibly by applying the patch, possibly by removing any hot spares so
>  recovery does not automatically start.
>
>  This patch will be sent upstream shortly and will subsequently appear in
>  future "-stable" kernels.
>
> NeilBrown
>
> From f94e37dce722ec7b6666fd04be357f422daa02b5 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 13 Aug 2014 09:57:07 +1000
> Subject: [PATCH] md/raid6: avoid data corruption during recovery of
>  double-degraded RAID6
>
> During recovery of a double-degraded RAID6 it is possible for
> some blocks not to be recovered properly, leading to corruption.
>
> If a write happens to one block in a stripe that would be written to a
> missing device, and at the same time that stripe is recovering data
> to the other missing device, then that recovered data may not be written.
>
> This patch skips, in the double-degraded case, an optimisation that is
> only safe for single-degraded arrays.
>
> Bug was introduced in 2.6.32 and fix is suitable for any kernel since
> then.  In an older kernel with separate handle_stripe5() and
> handle_stripe6() functions that patch must change handle_stripe6().
>
> Cc: stable@vger.kernel.org (2.6.32+)
> Fixes: 6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8
> Cc: Yuri Tikhonov <yur@emcraft.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: "Manibalan P" <pmanibalan@amiindia.co.in>
> Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1090423
> Signed-off-by: NeilBrown <neilb@suse.de>
>

Acked-by: Dan Williams <dan.j.williams@intel.com>

...with a capital "ACK"!.
