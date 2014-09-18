Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaIRSZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:25:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57473 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaIRSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:25:47 -0400
Date: Thu, 18 Sep 2014 11:25:37 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] firmware_class: make sure fw requests contain a name
Message-ID: <20140918182537.GA10260@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An empty firmware request name will trigger warnings when building
device names. Make sure this is caught earlier and rejected.

The warning was visible via the test_firmware.ko module interface:

echo -ne "\x00" > /sys/devices/virtual/misc/test_firmware/trigger_request

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
 drivers/base/firmware_class.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index bf424305f3dc..3d785ebb48d3 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1105,6 +1105,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
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


-- 
Kees Cook
Chrome OS Security
