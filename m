Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaK1JTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:19:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20334 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaK1JTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:19:37 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-60-54783e27b513
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v8 05/14] v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE control
Date: Fri, 28 Nov 2014 10:17:57 +0100
Message-id: <1417166286-27685-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV11u4oQg8tTVCw2zljPanF050Qm
	iyU/dzFZ9F59zmhxtukNu8XlXXPYLLa+Wcdo0bNhK6vF3VNH2Sx273rKanH4TTurxZn9K9kc
	eDym/N7I6rFz1l12j8NfF7J47Jn/g9Wjb8sqRo8Vq7+ze3zeJBfAHsVlk5Kak1mWWqRvl8CV
	cefTHeaCieIVr+YvZm1gnCjcxcjJISFgIvFy8SQ2CFtM4sK99UA2F4eQwHRGiaf9S9ghnHYm
	iUt7PjGDVLEJGEr8fPGaqYuRg0NEIFri0rF6kBpmgc+MEhffLwebJCwQIPFwxjUWEJtFQFXi
	+e2prCA2r4CHxKeevWC9EgIKEnMm2YCEOQU8JeZ+XssCEhYCKln0KmUCI+8CRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMGB+Ux6B+OqBotDjAIcjEo8vD//lYcIsSaWFVfmHmKU4GBW
	EuE99RUoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfGzdwQIYH0xJLU7NTUgtQimCwTB6dUA2Pf
	Wq/fL+fPSejv2CNwpCieubAhyW6rzVnGsrJ5IccD/hR8vV84s5HvYXgE44YLGWe/n9O+kawv
	3iC+LnKHbCRvx0ztsnWrs8/HX5ku0u1nkrTT6Ijwj8z3Dx123HocccLxcqHY2giPp3fYzqlE
	Sp5fFmPJvCuDnbOdz3KNDEvTQtvTdZzrpiixFGckGmoxFxUnAgAnTl4iSAIAAA==
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
index e013e4b..35e9ea3 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4563,6 +4563,15 @@ interface and may change in the future.</para>
     	    after strobe during which another strobe will not be
     	    possible. This is a read-only control.</entry>
     	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_SYNC_STROBE</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Synchronized strobe: whether the flash
+	    should be strobed synchronously with the other ones controlled
+	    by the same device</entry>
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

