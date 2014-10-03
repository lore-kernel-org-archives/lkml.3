Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaJCJnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:43:43 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38286 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJCJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:43:41 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/3] input: alps: Reset mouse before identifying it
Date: Fri,  3 Oct 2014 11:43:10 +0200
Message-Id: <1412329392-5580-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems after starting computer function alps_identify() does not detect
dual ALPS touchpad+trackstick device correctly and detect only touchpad.

Resetting ALPS device before identifiying it fixing this problem and both parts
touchpad and trackstick are detected.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 35a49bf..1bd5aa1 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2403,6 +2403,8 @@ int alps_detect(struct psmouse *psmouse, bool set_properties)
 {
 	struct alps_data dummy;
 
+	psmouse_reset(psmouse);
+
 	if (alps_identify(psmouse, &dummy) < 0)
 		return -1;
 
-- 
1.7.9.5

