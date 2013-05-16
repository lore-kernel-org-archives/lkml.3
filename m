Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3EPLtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:49:04 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:56249
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3EPLr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:47:26 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS
Date: Thu, 16 May 2013 05:21:19 -0700
Message-Id: <1368706879-32321-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368706879-32321-1-git-send-email-kys@microsoft.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The current
ringbuffer size can support this higher value.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 124cf0b..e2ab7cd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -328,7 +328,7 @@ static int storvsc_timeout = 180;
 module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
 
-#define STORVSC_MAX_IO_REQUESTS				128
+#define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
 
-- 
1.7.4.1

