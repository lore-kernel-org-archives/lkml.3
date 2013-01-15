Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3AOWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:46135 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab3AOWup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 077/171] udldrmfb: udl_get_edid: drop unneeded i--
Date: Tue, 15 Jan 2013 14:44:02 -0800
Message-Id: <20130115224318.962648456@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7b4cf994e4c6ba48872bb25253cc393b7fb74c82 upstream.

This is a left-over from when udl_get_edid returned the amount of bytes
successfully read, which it no longer does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_connector.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -40,7 +40,6 @@ static u8 *udl_get_edid(struct udl_devic
 				      HZ);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
-			i--;
 			goto error;
 		}
 		block[i] = rbuf[1];


