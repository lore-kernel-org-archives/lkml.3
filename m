Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936225AbaFIJXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:23:21 -0400
Received: from ns.horizon.com ([71.41.210.147]:37581 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933541AbaFIJXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:23:18 -0400
Date: 9 Jun 2014 05:23:17 -0400
Message-ID: <20140609092317.17828.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609040355.8126.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh, adventures in "unable to mount root filesystem" currently underway.

PEBKAC resolved.  (I had CONFIG_ATA=m for some testing, but forgot
to change it back to y when compiling a kernel I expected to boot.)

32 MiB write:

	    Without patch		With patch
0 readers: 0.495523 0.494998		0.515995 0.516026
1 reader:  0.842245 0.845308		0.704283 0.704318
2 readers: 1.18658  1.18762		0.904635 0.904844
3 readers: 1.49615  1.49616		1.14311  1.16836

I haven't rebooted back to the without-patch kernel to see if the 20 ms
loss is consistent, but obviously that needs fixing.  (There's more than
just that patch I posted in there.)

Anyway, it's noticeable, but maybe not worth fixing.

The interesting question is whether we should get rid of out[].
That's obscurity that contributes no security, and thus a Bad
Thing by definition.
