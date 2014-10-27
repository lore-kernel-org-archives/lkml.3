Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaJ0TMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:12:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaJ0TEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/105] firmware_class: make sure fw requests contain a name
Date: Mon, 27 Oct 2014 11:56:07 -0700
Message-Id: <1414436240-13879-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 471b095dfe0d693a8d624cbc716d1ee4d74eb437 upstream.

An empty firmware request name will trigger warnings when building
device names. Make sure this is caught earlier and rejected.

The warning was visible via the test_firmware.ko module interface:

echo -ne "\x00" > /sys/devices/virtual/misc/test_firmware/trigger_request

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/firmware_class.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index e2b51f8..88c4812 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1070,6 +1070,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (!firmware_p)
 		return -EINVAL;
 
+	if (!name || name[0] == '\0')
+		return -EINVAL;
+
 	ret = _request_firmware_prepare(&fw, name, device);
 	if (ret <= 0) /* error or already assigned */
 		goto out;
-- 
1.9.1

