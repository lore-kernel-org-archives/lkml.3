Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3ETCap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:30:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37114 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3ETCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:30:43 -0400
Message-ID: <51998AC0.3070501@huawei.com>
Date: Mon, 20 May 2013 10:30:24 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <matthew.garrett@nebula.com>
CC: <platform-driver-x86@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/3] x86: asus-laptop: fix invalid point access
References: <1368889004-5520-3-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1368889004-5520-3-git-send-email-libo.chen@huawei.com>
X-Forwarded-Message-Id: <1368889004-5520-3-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


asus->name is null or point to const string,so it is not suitable to kfree it.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/platform/x86/asus-laptop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0eea09c..8e268da 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1935,7 +1935,6 @@ fail_input:
 fail_backlight:
 	asus_platform_exit(asus);
 fail_platform:
-	kfree(asus->name);
 	kfree(asus);

 	return result;
-- 
1.8.1.2






