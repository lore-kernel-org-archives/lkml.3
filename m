Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbbANCyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:54:24 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:38670 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028AbbANCyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:54:23 -0500
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 21:54:22 EST
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E2eKRu024126, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 0/3] memstick: rtsx: finish request faster if no card exist
Date: Wed, 14 Jan 2015 10:40:14 +0800
Message-ID: <cover.1421202479.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

This pathset include some misc coding update.
- dump register using compact format.
  This prevent dump a lot of lines register dump when some error occurs.

- finish request if no card exist
  check card exist before sending any request, When card removed,
  request can returned much faster.

- move suspend/resume to pm ops
  Move suspend/resume pm ops instead of driver.suspend/drivers.resume,
  we tested in some case if we put it in driver.suspend/drivers.resume,
  the function will not called.

Micky Ching (3):
  memstick: rtsx: dump register using compact format
  memstick: rtsx: finish request if no card exist
  memstick: rtsx: move suspend/resume to pm ops

 drivers/memstick/host/rtsx_pci_ms.c | 89 ++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 40 deletions(-)

-- 
1.9.1

