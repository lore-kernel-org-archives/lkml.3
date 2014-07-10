Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaGJVzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:11 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52833 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaGJVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:08 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 36/83] hsa/radeon: fixing clock counters bug
Date: Fri, 11 Jul 2014 00:53:52 +0300
Message-Id: <1405029279-6894-8-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Fixed wrong reporting of timestamps in kfd_ioctl_get_clock_counters.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index dba6084..75fe11f 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -304,10 +304,10 @@ kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __u
 
 	/* No access to rdtsc. Using raw monotonic time */
 	getrawmonotonic(&time);
-	args.cpu_clock_counter = time.tv_nsec;
+	args.cpu_clock_counter = (uint64_t)timespec_to_ns(&time);
 
 	get_monotonic_boottime(&time);
-	args.system_clock_counter = time.tv_nsec;
+	args.system_clock_counter = (uint64_t)timespec_to_ns(&time);
 
 	/* Since the counter is in nano-seconds we use 1GHz frequency */
 	args.system_clock_freq = 1000000000;
-- 
1.9.1

