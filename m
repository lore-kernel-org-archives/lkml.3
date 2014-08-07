Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaHGNJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbaHGNJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:09:52 -0400
From: Amit Shah <amit.shah@redhat.com>
To: jgarzik@bitpay.com
Cc: hpa@linux.intel.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 1/2] rngd: add udev rule to source from hwrng if virtio-rng present
Date: Thu,  7 Aug 2014 18:38:59 +0530
Message-Id: <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com>
In-Reply-To: <cover.1407416628.git.amit.shah@redhat.com>
References: <cover.1407416628.git.amit.shah@redhat.com>
In-Reply-To: <cover.1407416628.git.amit.shah@redhat.com>
References: <cover.1407416628.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On KVM guests where the virtio-rng device is available, and set as the
current rng, this udev rule will start rngd which will feed in the
host-provided entropy to /dev/random.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 90-virtio-rng.rules | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 90-virtio-rng.rules

diff --git a/90-virtio-rng.rules b/90-virtio-rng.rules
new file mode 100644
index 0000000..07f2f9c
--- /dev/null
+++ b/90-virtio-rng.rules
@@ -0,0 +1 @@
+KERNEL=="hw_random", ATTR{rng_current}=="virtio*", RUN+="/sbin/rngd -r /dev/hwrng"
-- 
1.9.3

