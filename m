Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaLEPTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:19:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaLEPTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:19:14 -0500
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/2] mtd: mtd_oobtest: fix bitflip_limit usage in test case 3
Date: Fri, 5 Dec 2014 17:18:38 +0200
Message-ID: <1417792720-3017-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The bitflip_limit parameter was recently introduced to oobtest.
However, it didn't implement the bitflip_limit check for all cases in test case 3.
Patch 1 tackles the missed scenarios in test case 3, to adhere to bitflip_limit parameter.

Patch 2 extends the memory compare helper so that we can pass a non-zero offset to be
printed in the error message. This is useful in the vary_offset case when we need to
compare only a section of the OOB available block.

--
cheers,
-roger

Roger Quadros (2):
  mtd: mtd_oobtest: Fix bitflip_limit usage in test case 3
  mtd: mtd_oobtest: Fix the address offset with vary_offset case

 drivers/mtd/tests/oobtest.c | 79 ++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

-- 
2.1.0

