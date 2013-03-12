Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3CLF3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:29:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32301 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLF3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:29:03 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856442"
Message-ID: <513EBCC1.80906@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:27:29 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/18] driver: tty: serial: remove cast for kzalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:27:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:27:49,
	Serialize complete at 2013/03/12 13:27:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/icom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index bc9e6b0..18ed5ae 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1415,8 +1415,7 @@ static int icom_alloc_adapter(struct icom_adapter
 	struct icom_adapter *cur_adapter_entry;
 	struct list_head *tmp;
 
-	icom_adapter = (struct icom_adapter *)
-	    kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
+	icom_adapter = kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
 
 	if (!icom_adapter) {
 		return -ENOMEM;
-- 
1.7.1

