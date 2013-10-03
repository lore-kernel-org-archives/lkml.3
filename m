Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3JCER7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:17:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3JCER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:17:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [ 18/57] mei: cancel stall timers in mei_reset
Date: Wed,  2 Oct 2013 21:08:44 -0700
Message-Id: <20131003040637.858388712@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 4a704575cc1afb3b848f096778fa9b8d7b3d5813 upstream.

Unset init_clients_timer and amthif_stall_timers
in mei_reset in order to cancel timer ticking and hence
avoid recursive reset calls.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/amthif.c |    1 +
 drivers/misc/mei/init.c   |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -57,6 +57,7 @@ void mei_amthif_reset_params(struct mei_
 	dev->iamthif_ioctl = false;
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 	dev->iamthif_timer = 0;
+	dev->iamthif_stall_timer = 0;
 }
 
 /**
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -169,6 +169,9 @@ void mei_reset(struct mei_device *dev, i
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 	}
 
+	/* we're already in reset, cancel the init timer */
+	dev->init_clients_timer = 0;
+
 	dev->me_clients_num = 0;
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;


