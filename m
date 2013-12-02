Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3LBTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3LBTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 137/212] radeon/i2c: do not count reg index in number of i2c byte we are writing.
Date: Mon,  2 Dec 2013 11:15:28 -0800
Message-Id: <20131202191302.349684822@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit fae009d15a44e5f1d938340facf4b8bc7dc69a09 upstream.

Useless to count the register index in number of bytes we are writing.

Fixes a regression with hw i2c enabled.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_i2c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -56,8 +56,10 @@ static int radeon_process_i2c_ch(struct
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


