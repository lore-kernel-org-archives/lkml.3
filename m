Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbaJ1HSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:18:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaJ1Dnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3.16 034/127] firmware_class: make sure fw requests contain a name
Date: Tue, 28 Oct 2014 11:34:29 +0800
Message-Id: <20141028033422.410107857@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/base/firmware_class.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1086,6 +1086,9 @@ _request_firmware(const struct firmware
 	if (!firmware_p)
 		return -EINVAL;
 
+	if (!name || name[0] == '\0')
+		return -EINVAL;
+
 	ret = _request_firmware_prepare(&fw, name, device);
 	if (ret <= 0) /* error or already assigned */
 		goto out;


