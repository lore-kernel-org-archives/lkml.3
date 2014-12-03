Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaLCQIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaLCQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:46 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-93-547f3584cc63
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v9 13/19] v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE control
Date: Wed, 03 Dec 2014 17:06:48 +0100
Message-id: <1417622814-10845-14-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd0W0/oQg0t/BCw2zljPanF050Qm
	i/43C1ktlvzcxWRx7tVKRoveq88ZLc42vWG3uLxrDpvF1jfrGC16NmxltVh6/SKTxd1TR9ks
	Jkxfy2LRuvcIu8XuXU9ZLQ6/aWe1OLN/JZuDoMeaeWsYPab83sjqcbmvl8lj56y77B4rl39h
	8zj8dSGLx6ZVnWwee+b/YPXo27KK0WPF6u/sHp83yQVwR3HZpKTmZJalFunbJXBl3NuzkLFg
	tUTF8zv9jA2MXSJdjJwcEgImEpvOv2OBsMUkLtxbz9bFyMUhJDCdUeLRvU5mCKedSeLX5v3s
	IFVsAoYSP1+8Zupi5OAQEYiWuHSsHqSGWeAVk8STU42sIDXCAgESZ3+9B7NZBFQlbt7/AGbz
	CnhK3DqyjhWkV0JAQWLOJBuQMCdQ+OmP++wgYSEBD4mDE/0nMPIuYGRYxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREc8s+kdzCuarA4xCjAwajEw2sRVxcixJpYVlyZe4hRgoNZSYT32Teg
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd4bN3NDhATSE0tSs1NTC1KLYLJMHJxSDYxMZ3StlZ4q
	HxRV/Zhz488VW/eGv7Otn/+f82Xy0gzhGW8yPm1rjW4JcOdp82DU7xEsPlRxen1KxYPLfGY3
	u5Z8letlPXecSZlRpWK6d9G7/wff7f65akfWc5v3vQ/1HLeZB6gbqovfUXMs/unS3G374XD1
	m6zdTzd9l5L+3+AguK5HZP603mwlluKMREMt5qLiRABH2LPhdQIAAA==
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
 Documentation/DocBook/media/v4l/controls.xml |   11 +++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 14 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e013e4b..20179ab 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4563,6 +4563,17 @@ interface and may change in the future.</para>
     	    after strobe during which another strobe will not be
     	    possible. This is a read-only control.</entry>
     	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_SYNC_STROBE</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Synchronized strobe: whether the flash
+	    should be strobed synchronously with the other one controlled
+	    by the same device. Flash timeout setting is inherited from the
+	    LED being strobed explicitly and flash intensity setting of a LED
+	    being synchronized is used.</entry>
+    	  </row>
     	  <row><entry></entry></row>
     	</tbody>
           </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..a7cca8c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -846,6 +846,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_SYNC_STROBE:	return "Synchronize Strobe";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -949,6 +950,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STATUS:
 	case V4L2_CID_FLASH_CHARGE:
 	case V4L2_CID_FLASH_READY:
+	case V4L2_CID_FLASH_SYNC_STROBE:
 	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
 	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
 	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
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

