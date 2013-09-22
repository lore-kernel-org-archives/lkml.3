Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3IVUkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:40:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:35978 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3IVUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 00/12] random driver changes
Date: Sun, 22 Sep 2013 16:38:46 -0400
Message-Id: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent events have inspired me to take a closer look at the /dev/random
driver and make a number of changes to improve it.  The changes reflect
relatively minor changes across the entire /dev/random architecture,
including:

* how we collect entropy on non-x86 architectures
* optimizing the CPU overhead when we collect entropy
* improving our entropy accumulation estimates
* small changes to the mixing function suggested by researchers who have
	been analyzing the /dev/random driver

I would appreciate folks taking a look at the changes and making any
comments, asking questions, etc.

Cheers!

						- Ted

H. Peter Anvin (3):
  random: Statically compute poolbitshift, poolbytes, poolbits
  random: Allow fractional bits to be tracked
  random: Account for entropy loss due to overwrites

Theodore Ts'o (9):
  random: run random_int_secret_init() run after all late_initcalls
  random: fix the tracepoint for get_random_bytes(_arch)
  random: optimize spinlock use in add_device_randomness()
  random: allow architectures to optionally define random_get_entropy()
  random: mix in architectural randomness earlier in extract_buf()
  random: optimize the entropy_store structure
  random: cap the rate which the /dev/urandom pool gets reseeded
  random: speed up the fast_mix function by a factor of four
  random: adjust the generator polynomials in the mixing function
    slightly

 drivers/char/random.c         | 419 +++++++++++++++++++++++++++---------------
 include/linux/random.h        |   1 +
 include/linux/timex.h         |  17 ++
 include/trace/events/random.h |  33 +++-
 init/main.c                   |   2 +
 5 files changed, 321 insertions(+), 151 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

