Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaFLBvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:51:41 -0400
Received: from ns.horizon.com ([71.41.210.147]:16646 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754411AbaFLBvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:51:40 -0400
Date: 11 Jun 2014 21:51:39 -0400
Message-ID: <20140612015139.21573.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@horizon.com, mingo@kernel.org, price@mit.edu, tytso@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
In-Reply-To: <5398F7F9.9000106@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sadly I can't find the tree, but I'm 94% sure it was Skein-256
> (specifically the SHA3-256 candidate parameter set.)

It would be nice to have two hash functions, optimized separately for 32-
and 64-bit processors.  As the Skein report says, the algorithm can
be adapted to 32 bits easily enough.

I also did some work a while ago to adapt the Skein parameter search
code to develop a Skein-192 (6x32 bits) that would fit into registers
on x86-32.  (It got stalled when I e-mailed Niels Ferguson about it
and never heard back; it fell off the to-do list while I was waiting.)

The intended target was IPv6 address hashing for sequence number
randomization, but it could be used for pool hashing, too.
