Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3FEF6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:58:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43035 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3FEF6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:58:00 -0400
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 15:57:59 +1000
X-Google-Sender-Auth: EfjhtHJd3Q0TflP3yxX0vVsIiHY
Message-ID: <CAEgOgz6jjh9-G6PmzrjJcG7LKCnh4cAooSnCiZ9cmz_qUs8AXg@mail.gmail.com>
Subject: [RFC] Micron M25P80 Part name variants
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: Liming Wang <walimisdev@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, linux-mtd@lists.infradead.org,
        Ed Maste <emaste@freebsd.org>, suneelg@xilinx.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

For micron M25P80 parts there is a mix of naming conventions in the
device table:

        /* Micron */
        { "n25q064",  INFO(0x20ba17, 0, 64 * 1024, 128, 0) },
        { "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024, 256, 0) },
        { "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024, 256, 0) },
        { "n25q256a", INFO(0x20ba19, 0, 64 * 1024, 512, SECT_4K) },

n25q128 has a11 and a13 variants, while 256 does not. Should this be
consistent across parts? If so should we adopt Liming Wangs "axx"
precedent universally? Here is a hunk from Ed Maste that applies the
relevant change to QEMU (currently on list) that would be nice to
merge. Can we fix this Linux side in similar fashion?

     /* Micron */
-    { INFO("n25q032a",    0x20bb16,      0,  64 << 10,  64, ER_4K) },
-    { INFO("n25q128a11",  0x20bb18,      0,  64 << 10, 256, 0) },
-    { INFO("n25q128a13",  0x20ba18,      0,  64 << 10, 256, 0) },
-    { INFO("n25q256a",    0x20ba19,      0,  64 << 10, 512, ER_4K) },
+    { INFO("n25q032a11",  0x20bb16,      0,  64 << 10,  64, ER_4K) },
+    { INFO("n25q032a13",  0x20ba16,      0,  64 << 10,  64, ER_4K) },
+    { INFO("n25q064a11",  0x20bb17,      0,  64 << 10, 128, ER_4K) },
+    { INFO("n25q064a13",  0x20ba17,      0,  64 << 10, 128, ER_4K) },
+    { INFO("n25q128a11",  0x20bb18,      0,  64 << 10, 256, ER_4K) },
+    { INFO("n25q128a13",  0x20ba18,      0,  64 << 10, 256, ER_4K) },
+    { INFO("n25q256a11",  0x20bb19,      0,  64 << 10, 512, ER_4K) },
+    { INFO("n25q256a13",  0x20ba19,      0,  64 << 10, 512, ER_4K) },

Regards,
Peter
