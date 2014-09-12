Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaILCPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:15:09 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41468 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaILCPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:15:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8C1USiu012672, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 0/2] mfd: rtsx: fix PM suspend for 5227 & 5249
Date: Fri, 12 Sep 2014 09:30:26 +0800
Message-ID: <cover.1410484754.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

v2:
using (err < 0) to check if a function failed, not using
"if (err)" and "if (err < 0)" in mixing way.

This patch fix rts5227 and rts5249 suspend issue, when card reader
resumed from suspend state, the power state should reset before send
buffer command. The original not reset PM state first, so this will
lead resume failed, and can not do anything more.

Micky Ching (2):
  mfd: rtsx: fix PM suspend for 5227
  mfd: rtsx: fix PM suspend for 5249

 drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
 drivers/mfd/rts5249.c        |   17 +++++++++++++++++
 include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
 3 files changed, 48 insertions(+)

--
1.7.9.5
