Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3CNLDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:03:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3CNKhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 17/88] sony-laptop: fully enable SNY controlled modems
Date: Thu, 14 Mar 2013 10:35:10 +0000
Message-Id: <1363257381-15900-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Dongili <malattia@linux.it>

commit 3ec1c3983d73b1e3d4cfd72afab94c34eceafe8a upstream.

The call to handlers 0x124 and 0x135 (rfkill control) seems to take a
bitmask to control various states of the device. For our rfkill we need
a fully on/off. SVZ1311Z9R/X's LTE modem needs more bits up.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47751
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/sony-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index d4a6172..edbb51f 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1528,7 +1528,7 @@ static int sony_nc_rfkill_set(void *data, bool blocked)
 	int argument = sony_rfkill_address[(long) data] + 0x100;
 
 	if (!blocked)
-		argument |= 0x030000;
+		argument |= 0x070000;
 
 	return sony_call_snc_handle(sony_rfkill_handle, argument, &result);
 }
-- 
1.8.1.2

