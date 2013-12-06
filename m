Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab3LFVy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:54:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3LFVyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kefeng Wang <wangkefeng.wang@huawei.com>, stable@kernel.org
Subject: [PATCH 3.4 25/32] HID: picolcd_core: validate output report details
Date: Fri,  6 Dec 2013 13:52:35 -0800
Message-Id: <20131206214959.125240499@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 1e87a2456b0227ca4ab881e19a11bb99d164e792 upstream.

A HID device could send a malicious output report that would cause the
picolcd HID driver to trigger a NULL dereference during attr file writing.

[jkosina@suse.cz: changed

	report->maxfield < 1

to

	report->maxfield != 1

as suggested by Bruno].

CVE-2013-2899

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@kernel.org
Reviewed-by: Bruno Prémont <bonbons@linux-vserver.org>
Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[Kefeng: backported to stable 3.4: adjust filename]
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-picolcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1424,7 +1424,7 @@ static ssize_t picolcd_operation_mode_st
 		buf += 10;
 		cnt -= 10;
 	}
-	if (!report)
+	if (!report || report->maxfield != 1)
 		return -EINVAL;
 
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))


