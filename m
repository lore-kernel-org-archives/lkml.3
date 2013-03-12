Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3CLFfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:35:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLFfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:35:02 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856482"
Message-ID: <513EBE27.4060201@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:33:27 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/18] driver: usb: storage: remove cast for kmalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:33:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:33:48,
	Serialize complete at 2013/03/12 13:33:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
---
 drivers/usb/storage/isd200.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index ecea478..06a3d22 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1457,8 +1457,7 @@ static int isd200_init_info(struct us_data *us)
 		retStatus = ISD200_ERROR;
 	else {
 		info->id = kzalloc(ATA_ID_WORDS * 2, GFP_KERNEL);
-		info->RegsBuf = (unsigned char *)
-				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
+		info->RegsBuf = kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
 		info->srb.sense_buffer =
 				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
 		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
-- 
1.7.1

