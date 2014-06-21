Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbaFUAjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:39:49 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41794 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbaFUAjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:39:47 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hariprasad@chelsio.com, leedom@chelsio.com
Cc: poswald@suse.com, santosh@chelsio.com, jcheung@suse.com, dchang@suse.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@suse.com
Subject: [RFT 0/3] cxgb4: use request_firmware_nowait()
Date: Fri, 20 Jun 2014 17:39:38 -0700
Message-Id: <1403311181-9328-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Its reported that loading the cxgb4 can take over 1 minute,
use the more sane request_firmware_nowait() API call just
in case this amount of time is causing issues. The driver
uses the firmware API 3 times, one for the firmware, one
for configuration and another one for flash, this provides
the port for all cases.

I don't have the hardware so please test. I did verify we
can use this during pci probe and also during the ethtool
flash callback.

Luis R. Rodriguez (3):
  cxgb4: make ethtool set_flash use request_firmware_nowait()
  cxgb4: make configuration load use request_firmware_nowait()
  cxgb4: make device firmware load use request_firmware_nowait()

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  13 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 258 +++++++++++++++---------
 2 files changed, 176 insertions(+), 95 deletions(-)

-- 
2.0.0

