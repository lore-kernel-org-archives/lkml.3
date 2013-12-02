Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3LBUbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:31:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3LBTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.10 167/173] drm/radeon: re-enable sw ACR support on pre-DCE4
Date: Mon,  2 Dec 2013 11:12:30 -0800
Message-Id: <20131202191202.236756330@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b852c985010a77c850b7548d64bbb964ca462b02 upstream.

HW ACR support may have issues on some older chips, so
use SW ACR for now until we've tested further.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -320,6 +320,7 @@ void r600_hdmi_setmode(struct drm_encode
 	}
 
 	WREG32(HDMI0_ACR_PACKET_CONTROL + offset,
+	       HDMI0_ACR_SOURCE | /* select SW CTS value - XXX verify that hw CTS works on all families */
 	       HDMI0_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	WREG32(HDMI0_VBI_PACKET_CONTROL + offset,


