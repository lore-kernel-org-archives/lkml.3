Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3LSMSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:18:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3LSL7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 155/208] radeon/i2c: do not count reg index in number of i2c byte we are writing.
Date: Thu, 19 Dec 2013 11:54:13 +0000
Message-Id: <1387454106-19326-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit fae009d15a44e5f1d938340facf4b8bc7dc69a09 upstream.

Useless to count the register index in number of bytes we are writing.

Fixes a regression with hw i2c enabled.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_i2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index deaf98c..0652ee0 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -56,8 +56,10 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 			return -EINVAL;
 		}
 		args.ucRegIndex = buf[0];
-		if (num > 1)
-			memcpy(&out, &buf[1], num - 1);
+		if (num > 1) {
+			num--;
+			memcpy(&out, &buf[1], num);
+		}
 		args.lpI2CDataOut = cpu_to_le16(out);
 	} else {
 		if (num > ATOM_MAX_HW_I2C_READ) {
-- 
1.8.3.2

