Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaCDWkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:40:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:62908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbaCDWkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:40:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,588,1389772800"; 
   d="scan'208";a="494106881"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 0/3] RDSEED support for the Linux kernel
Date: Tue,  4 Mar 2014 14:40:12 -0800
Message-Id: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Upcoming Intel silicon adds a new RDSEED instruction.  Whereas RDRAND
returns output from a PRNG, the RDSEED instruction returns fully
conditioned entropy that is suitable for use as seeds to a PRNG.

This patchset adds support for RDSEED in the Linux kernel in three
places:

1. During bootup, use RDSEED to initialize the entropy pool if
   available (we already use RDRAND for this).  We don't add any
   credit at this point, but it will give much better starting point.

2. In the slow path to add_interrupt_randomness, executed once per
   second, we take a single RDSEED sample and mix it into the entropy
   pool, crediting it at 50% of its rated entropy.  This was suggested
   by Linus.

3. If we are about to block on /dev/random due to lack of entropy,
   attempt an "emergency pool refill" using RDSEED.

Comments are, of course, appreciated.

	-hpa

