Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHQCG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 22:06:29 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:43861
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaHQCG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 22:06:28 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with hot-add/remove of LUNs 
Date: Sat, 16 Aug 2014 20:09:14 -0700
Message-Id: <1408244954-27417-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set addresses issues with LUN hot-add and remove. When the host
notifies the guest that a scan is needed, scan the host. Also, prior to
discovering new devices that may have been added, ensure we handle the
LUN remove case first.

K. Y. Srinivasan (2):
  Drivers: scsi: storvsc: In responce to a scan event, scan the host
  Drivers: scsi: storvsc: Force discovery of LUNs that may have been
    removed.

 drivers/scsi/storvsc_drv.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 11 deletions(-)

-- 
1.7.4.1

