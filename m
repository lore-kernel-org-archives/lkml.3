Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaLEW6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:58:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaLEW43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Binyamin Sagal <bensagal@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 49/73] Input: synaptics - adjust min/max on Thinkpad E540
Date: Fri,  5 Dec 2014 14:44:55 -0800
Message-Id: <20141205224435.406642293@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Sagal <bensagal@gmail.com>

commit bce4f9e764c36bc35dd5c9cf9e057c09f422397d upstream.

The LEN2006 Synaptics touchpad (as found in Thinkpad E540) returns wrong
min max values.

touchpad-edge-detector output:
>  Touchpad SynPS/2 Synaptics TouchPad on /dev/input/event6
>  Move one finger around the touchpad to detect the actual edges
>  Kernel says:    x [1472..5674], y [1408..4684]
>  Touchpad sends: x [1264..5675], y [1171..4688]

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=88211
Signed-off-by: Binyamin Sagal <bensagal@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -140,6 +140,10 @@ static const struct min_max_quirk min_ma
 		(const char * const []){"LEN2001", NULL},
 		1024, 5022, 2508, 4832
 	},
+	{
+		(const char * const []){"LEN2006", NULL},
+		1264, 5675, 1171, 4688
+	},
 	{ }
 };
 


