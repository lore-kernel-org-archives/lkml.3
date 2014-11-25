Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaKYKmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaKYKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Gerecke <jason.gerecke@wacom.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 136/254] HID: input: Fix TransducerSerialNumber implementation
Date: Tue, 25 Nov 2014 10:38:06 +0000
Message-Id: <1416912004-5928-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <killertofu@gmail.com>

commit 5989a55a4c9aafba8b152c6bf52244510c2b88b9 upstream.

The commit which introduced TransducerSerialNumber (368c966) is missing
two crucial implementation details. Firstly, the commit does not set the
type/code/bit/max fields as expected later down the code which can cause
the driver to crash when a tablet with this usage is connected. Secondly,
the call to 'set_bit' causes MSC_PULSELED to be sent instead of the
expected MSC_SERIAL. This commit addreses both issues.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 2619f7f4517a..cb1b3faedb97 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -689,7 +689,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 
 		case 0x5b: /* TransducerSerialNumber */
-			set_bit(MSC_SERIAL, input->mscbit);
+			usage->type = EV_MSC;
+			usage->code = MSC_SERIAL;
+			bit = input->mscbit;
+			max = MSC_MAX;
 			break;
 
 		default:  goto unknown;
-- 
2.1.0

