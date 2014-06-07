Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaFGISb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 04:18:31 -0400
Received: from ns.horizon.com ([71.41.210.147]:24620 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbaFGIS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 04:18:29 -0400
Date: 7 Jun 2014 04:18:28 -0400
Message-ID: <20140607081828.9294.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, shemminger@osdl.org,
        tytso@mit.edu
Subject: [PATCH 0/7] random32: Various minor cleanups
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking for self-test code to emulate for lib/glob.c and, while
canvassing other code with self-tests, found some code that made me itch,
so I scratched it.

7 patches;

1/7: Mark the self-test data as __initconst
2/7: Remove excess calls to prandom_u32_state in initialization
3/7: Replace an #ifdef with a stub prandom_state_selftest()
4/7: Use <asm/unaligned.h> instead of hand-rolling it
5/7: Make prandom_u32_max efficient for powers of 2
6/7: Randomize timeout to the millisecond, not the second
7/7: Remove redundant U suffixes on integers

I have a big follow-on patch series to replace all the (many) instances
of "prandom_u32() % x" in the kernel with prandom_u32_max(x), which is
more efficient.

As of patch 5/7, "prandom_u32() & (x-1)" can also be replaced by
"prandom_u32_max(x)", but that's optional.

Patch 6/7 is dubious, and I'd like comments.  I just don't see
a reason why integer granularity would be desirable.
