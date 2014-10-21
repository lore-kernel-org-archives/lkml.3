Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaJUNyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:54:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbaJUNyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:54:10 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/2] mtd: oobtest: Add parameter to ignore bitflip errors within specified limit
Date: Tue, 21 Oct 2014 16:53:26 +0300
Message-ID: <1413899608-3911-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The oobtest case uses raw NAND read/writes to OOB area bypassing the error correction
mechanism and hence is bound to be affected by bitflip errors which are normal
in NAND memories. (e.g. we can never get DRA7-evm's NAND to fully pass
mtd_oobtest).

In these patches we add a module parameter "bitflip_limit" to specify how many
bitflips per page are tolerable. Not specifiing the parameter defaults to old
behaviour (i.e. zero bitflips tolerated).
Specifying bitflip_limit=1 makes us pass on DRA7-evm with 0 errors.

Introduce a new memcmpshow() function that shows the data byte where comparison failed.
This is useful for debugging. The same function is also used to calculate number of
bitflip errors over the data block.

cheers,
-roger

Roger Quadros (2):
  mtd: mtd_oobtest: Show the verification error location and data
  mtd: mtd_oobtest: add bitflip_limit parameter

 drivers/mtd/tests/oobtest.c | 77 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 13 deletions(-)

-- 
1.8.3.2

