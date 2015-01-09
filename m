Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbbAIPYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23439 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbbAIPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:44 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-79-54aff2bbaf5c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v10 14/19] v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE
 control
Date: Fri, 09 Jan 2015 16:23:04 +0100
Message-id: <1420816989-1808-15-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd3dn9aHGNyew22xccZ6VoujOycy
	Wcw/co7VYsnPXUwWvVefM1qcbXrDbnF51xw2i61v1jFa9GzYympx99RRNovdu56yWhx+085q
	cWb/SjYHXo8pvzeyeuycdZfd4/DXhSwee+b/YPXo27KK0WPF6u/sHp83yQWwR3HZpKTmZJal
	FunbJXBl9PRuZiu4KlZx+dtytgbGs0JdjJwcEgImEnMu72CDsMUkLtxbD2RzcQgJTGeU+Ni8
	lRHCaWeSOPt8DyNIFZuAocTPF6+Zuhg5OEQEoiUuHasHqWEWmMgkceficxaQGmGBYImrl3cw
	g9gsAqoS+8/cZgWxeQU8JBZP/MMG0ishoCAxZ5INiMkJFG757QRiCgm4S7y5ajiBkXcBI8Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAAfSa9g3FVg8UhRgEORiUe3g1y60OEWBPLiitz
	DzFKcDArifA2bAYK8aYkVlalFuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2CyTJx
	cEo1MIp8c8/i9LbV/R9teGONxrYXRwW9Zx3sUT/JNO++WdMe6X+LpnRZZ30S6HpesLao9v88
	tWoNw7RJu7z6O9UVV36qexLo5ZDtECR4f+OL2RMMV6Ys/SL2Ulgy9Hszd/6Zgq3bfYqmyXkl
	1x/7oZGqW3FZyekz527R5WweWtMDpXSbb87JOxpXrsRSnJFoqMVcVJwIAMLFCXRMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add V4L2_CID_FLASH_SYNC_STROBE control for determining
whether a flash device strobe has to be synchronized
with other flash leds controller by the same device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    9 +++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 12 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e013e4b..8380b07e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4563,6 +4563,15 @@ interface and may change in the future.</para>
     	    after strobe during which another strobe will not be
     	    possible. This is a read-only control.</entry>
     	  </row>
+    	  <row>
+            <entry spanname="id"><constant>V4L2_CID_FLASH_SYNC_STROBE</constant></entry>
+            <entry>menu</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Synchronized strobe: whether the flash
+	    should be strobed synchronously with the other one controlled
+	    by the same device.</entry>
+    	  </row>
     	  <row><entry></entry></row>
     	</tbody>
           </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..4bc7e00 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -846,6 +846,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_SYNC_STROBE:	return "Synchronize Strobe";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1041,6 +1042,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
+	case V4L2_CID_FLASH_SYNC_STROBE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 661f119..5bce13d 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -833,6 +833,7 @@ enum v4l2_flash_strobe_source {
 
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
+#define V4L2_CID_FLASH_SYNC_STROBE		(V4L2_CID_FLASH_CLASS_BASE + 13)
 
 
 /* JPEG-class control IDs */
-- 
1.7.9.5

