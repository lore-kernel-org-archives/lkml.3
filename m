Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbbAYRS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:18:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:8324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbbAYRSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:18:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,463,1418112000"; 
   d="scan'208";a="656230296"
Date: Mon, 26 Jan 2015 01:17:54 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH char-misc] Drivers: hv: vmbus: hv_process_timer_expiration()
 can be static
Message-ID: <20150125171754.GA25147@snb>
References: <201501260143.KqbhD5l0%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501260143.KqbhD5l0%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/hv/vmbus_drv.c:582:6: sparse: symbol 'hv_process_timer_expiration' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 vmbus_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 7488111..35e3f42 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -579,7 +579,7 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
-void hv_process_timer_expiration(struct hv_message *msg, int cpu)
+static void hv_process_timer_expiration(struct hv_message *msg, int cpu)
 {
 	struct clock_event_device *dev = hv_context.clk_evt[cpu];
 
