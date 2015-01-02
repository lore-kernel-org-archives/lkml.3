Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbbABClM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 21:41:12 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54030 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbABClJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 21:41:09 -0500
From: Erico Nunes <nunes.erico@gmail.com>
To: michal.simek@xilinx.com
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
        Erico Nunes <nunes.erico@gmail.com>
Subject: [PATCH] microblaze: Add missing PVR version codes
Date: Fri,  2 Jan 2015 00:40:33 -0200
Message-Id: <1420166433-12712-1-git-send-email-nunes.erico@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVR version code was missing in the cpu_ver_lookup table for the following
versions: 8.50.b 8.50.c 9.2 9.3

This caused /proc/cpuinfo to display "CPU-Ver: Unknown" for these versions.

This was detected and the patch tested with MicroBlaze version 8.50.c.
The other codes were taken from the Xilinx MicroBlaze Processor Reference
Guides UG081 (v14.7) and UG984 (v2014.1).

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index 234acad..b60442d 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -41,8 +41,12 @@ const struct cpu_ver_key cpu_ver_lookup[] = {
 	{"8.40.a", 0x18},
 	{"8.40.b", 0x19},
 	{"8.50.a", 0x1a},
+	{"8.50.b", 0x1c},
+	{"8.50.c", 0x1e},
 	{"9.0", 0x1b},
 	{"9.1", 0x1d},
+	{"9.2", 0x1f},
+	{"9.3", 0x20},
 	{NULL, 0},
 };
 
-- 
2.2.1

