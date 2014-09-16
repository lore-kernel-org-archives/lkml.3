Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaIPTDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbaIPTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:03:42 -0400
Date: Tue, 16 Sep 2014 15:03:30 -0400
From: Kyle McMartin <kyle@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, alexander.deucher@amd.com,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/radeon: delete unused PTE_* defines
Message-ID: <20140916190329.GN22012@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They don't appear to be used anywhere... elsewhere uses R*_PTE_*.

master@linux:U:.% git grep PTE_ -- drivers/gpu/drm/radeon | grep -v _PTE_
master@linux:U:.%	(kyle@redacted:~/linux)

./arch/arm64/include/asm/pgtable.h:27:0: note: this is the location of the previous definition
 #define PTE_VALID  (_AT(pteval_t, 1) << 0)
 ^
In file included from drivers/gpu/drm/radeon/r600_cs.c:31:0:
drivers/gpu/drm/radeon/r600d.h:48:0: warning: "PTE_VALID" redefined [enabled by default]
 #define PTE_VALID    (1 << 0)
 ^
In file included from ./arch/arm64/include/asm/io.h:29:0,
                 from include/linux/clocksource.h:19,
                 from include/clocksource/arm_arch_timer.h:19,
                 from ./arch/arm64/include/asm/arch_timer.h:27,
                 from ./arch/arm64/include/asm/timex.h:19,
                 from include/linux/timex.h:65,
<snip>
                 from include/drm/drmP.h:51,
                 from drivers/gpu/drm/radeon/r600_cs.c:29:
./arch/arm64/include/asm/pgtable.h:27:0: note: this is the location of the previous definition
 #define PTE_VALID  (_AT(pteval_t, 1) << 0)
 ^

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -44,13 +44,6 @@
 #define R6XX_MAX_PIPES				8
 #define R6XX_MAX_PIPES_MASK			0xff
 
-/* PTE flags */
-#define PTE_VALID				(1 << 0)
-#define PTE_SYSTEM				(1 << 1)
-#define PTE_SNOOPED				(1 << 2)
-#define PTE_READABLE				(1 << 5)
-#define PTE_WRITEABLE				(1 << 6)
-
 /* tiling bits */
 #define     ARRAY_LINEAR_GENERAL              0x00000000
 #define     ARRAY_LINEAR_ALIGNED              0x00000001
