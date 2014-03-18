Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaCRMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:25:29 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:34085 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRMZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 18 Mar 2014 08:25:27 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 08:25:27 EDT
Message-Id: <53284765020000A100014E30@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 18 Mar 2014 13:17:25 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q on ioctl BLKGETSIZE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm wondering (on a x86_64 SLES11 system):

"man 4 sd" says:
---
       BLKGETSIZE
              Returns the device size  in  sectors.   The  ioctl(2)  parameter
              should be a pointer to a long.
---

/usr/src/linux/block/ioctl.c (3.0.101-0.15) reads:
---
        case BLKGETSIZE:
                size = i_size_read(bdev->bd_inode);
                if ((size >> 9) > ~0UL)
                        return -EFBIG;
                return put_ulong(arg, size >> 9);
---

Three questions:
1) Shouldn't the manual page says that the sector size of always 512 Bytes, even on new disks with larger sectors?
2) Should the real sector size be used for new disks?
3) When using 512-bytes sector size, isn't the capacity limited to 2TB (2^31 kB)?

I'm not subscribed to LKML, so please keep me CC'd when answering.

Regards,
Ulrich


