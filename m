Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaGTQRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 12:17:48 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40219 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGTQRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 12:17:47 -0400
From: Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Commit d9e7972619334656 breaks KVM's virtio-rng-pci
Date: Sun, 20 Jul 2014 18:18:13 +0200
Message-Id: <84D489B9-FC60-40F1-A03F-996256F790A9@holtmann.org>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Cooper <jason@lakedaemon.net>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
To: LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the commit d9e7972619334656 ends up being responsible that using "-device virtio-rng-pci" in KVM no longer works.

	From: Kees Cook <keescook@chromium.org>
	Date: Mon, 3 Mar 2014 15:51:48 -0800
	Subject: [PATCH] hwrng: add randomness to system from rng sources

	When bringing a new RNG source online, it seems like it would make sense
	to use some of its bytes to make the system entropy pool more random,
	as done with all sorts of other devices that contain per-device or
	per-boot differences.

When providing "-device virtio-rng-pci" to a kernel with the above commit, the kernel never finishes booting. It just stops. My guess it is waiting for some magic entropy to appear.

Maybe this is something that should be fixed in virtio-rng driver instead of reverting this patch, but I leave this to the experts in this area.

Regards

Marcel

