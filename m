Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3KELhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16710 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3KELhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:31 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-15-5278d87a1915
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 00/11] skd: various fixes/cleanups
Date: Tue, 05 Nov 2013 12:36:58 +0100
Message-id: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t9jQd2qGxVBBg8aOSx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgypj6+xBTwUvOipmXCxoYOzi6GDk4JARMJP4vUupi5AQyxSQu3FvP1sXIxSEk
	MJ1RYvPPS4wQTheTxLXDixhBqtgErCQmtq8Cs0UEhCX2d7SygBQxCyxglJi8Yw47SEJYwFRi
	aXsnC8gGFgFViYP/ykDCvALuEgtmT2eC2CYv8fR+H9sERu4FjAyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYLD4pn0DsZVDRaHGAU4GJV4eC+GVgQJsSaWFVfmHmKU4GBWEuFtOwIU4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLggo5V5ln5B0Jtv
	t1aKb1f8Xt5+r2Nx7ZUgv7XfDJvV4z5HOkW7pvwPUHhqdl3Sa2FyqsPXuCXtXBdiYvwVbJvc
	X+94t9nji9Smx8vKzj6NLXrGZSF2/GZPvWiTseG2Cdv9F75I5zbb4H3zeM1s1pwp+3wt5j36
	/8Rr4hy1/SvyT68NWzpRZZ8SS3FGoqEWc1FxIgBepmEtBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a bunch of fixes/cleanups for the new skd driver.

Reference to v1:
	https://lkml.org/lkml/2013/9/30/279

Changes since v1:
- synced against for-3.13/drivers branch (commit 76c4a6f) of block tree
- dropped no longer needed patch #4 ("skd: alloc flush slab only if some
  devices are present"), #12 ("skd: reorder skd_flush_cmd_[en,de]queue()
  code") and #14 ("skd: remove skd_bio code")

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

Bartlomiej Zolnierkiewicz (11):
  skd: fix unregister_blkdev() placement
  skd: fix error paths in skd_init()
  skd: fix error messages in skd_init()
  skd: register block device only if some devices are present
  skd: remove SCSI subsystem specific includes
  skd: use <asm/unaligned.h>
  skd: remove redundant skdev->pdev assignment from skd_pci_probe()
  skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
  skd: cleanup skd_do_inq_page_da()
  skd: reorder construct/destruct code
  skd: fix formatting in skd_s1120.h

 drivers/block/skd_main.c  | 393 +++++++++++++++++++++-------------------------
 drivers/block/skd_s1120.h | 244 +++++++++++++---------------
 2 files changed, 286 insertions(+), 351 deletions(-)

-- 
1.8.2.3

