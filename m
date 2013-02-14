Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab3BNK4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:56:20 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:32255 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3BNK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:56:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,664,1355097600"; 
   d="scan'208";a="1454760"
Message-ID: <511CC2E5.4090400@citrix.com>
Date: Thu, 14 Feb 2013 11:56:37 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen-blkback: use balloon pages for persistent grants
References: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/13 11:12, Roger Pau Monne wrote:
> With current persistent grants implementation we are not freeing the
> persistent grants after we disconnect the device. Since grant map
> operations change the mfn of the allocated page, and we can no longer
> pass it to __free_page without setting the mfn to a sane value, use
> balloon grant pages instead, as the gntdev device does.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I think this patch is missing the following change in Kconfig, but 
gntdev doesn't depend on the balloon driver, which it also uses, so I'm 
not sure.

---
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f529407..74e2415 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -488,7 +488,7 @@ config XEN_BLKDEV_FRONTEND
 
 config XEN_BLKDEV_BACKEND
 	tristate "Xen block-device backend driver"
-	depends on XEN_BACKEND
+	depends on XEN_BACKEND && XEN_BALLOON
 	help
 	  The block-device backend driver allows the kernel to export its
 	  block devices to other guests via a high-performance shared-memory



