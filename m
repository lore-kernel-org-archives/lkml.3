Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbbA1F14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:27:56 -0500
Received: from mail.kernel.org ([198.145.29.136]:37056 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbbA1EOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:38 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 015/177] firmware_class: make sure fw requests contain a name
Date: Wed, 28 Jan 2015 12:06:37 +0800
Message-Id: <1422418236-12852-30-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 471b095dfe0d693a8d624cbc716d1ee4d74eb437 upstream.

An empty firmware request name will trigger warnings when building
device names. Make sure this is caught earlier and rejected.

The warning was visible via the test_firmware.ko module interface:

echo -ne "\x00" > /sys/devices/virtual/misc/test_firmware/trigger_request

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/base/firmware_class.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5401814..b7a4fe5 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -588,6 +588,9 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 	struct firmware_priv *fw_priv;
 	int ret;
 
+	if (!name || name[0] == '\0')
+		return -EINVAL;
+
 	fw_priv = _request_firmware_prepare(firmware_p, name, device, true,
 					    false);
 	if (IS_ERR_OR_NULL(fw_priv))
-- 
1.9.1

