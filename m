Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaJFVER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:04:17 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:61552 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaJFVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:04:13 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Hans de Goede <hdegoede@redhat.com>, Pawel Osciak <posciak@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        Zach Kuznia <zork@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH v5 1/2] [media] V4L: Add camera pan/tilt speed controls
Date: Mon,  6 Oct 2014 14:04:08 -0700
Message-Id: <1412629448-16348-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <CAP_ceTznJfoE2CNzU+=Ysnx_pNbmUeggOPCEzysvUP9YnSiGgg@mail.gmail.com>
References: <CAP_ceTznJfoE2CNzU+=Ysnx_pNbmUeggOPCEzysvUP9YnSiGgg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The V4L2_CID_PAN_SPEED and V4L2_CID_TILT_SPEED controls allow to move the
camera by setting its rotation speed around its axis.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Reviewed-by: Pawel Osciak <posciak@chromium.org>
---
Changes from v1:
- update the documentation wording according to Pawel suggestion.
Changes from v2:
- bump Linux kernel version for the API change.

 Documentation/DocBook/media/v4l/compat.xml   | 10 ++++++++++
 Documentation/DocBook/media/v4l/controls.xml | 21 +++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  2 ++
 4 files changed, 35 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 3a626d1..0a2debf 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2569,6 +2569,16 @@ fields changed from _s32 to _u32.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.18</title>
+      <orderedlist>
+	<listitem>
+	  <para>Added <constant>V4L2_CID_PAN_SPEED</constant> and
+ <constant>V4L2_CID_TILT_SPEED</constant> camera controls.</para>
+	</listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9f5ffd8..124f287 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3965,6 +3965,27 @@ by exposure, white balance or focus controls.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PAN_SPEED</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control turns the
+camera horizontally at the specific speed. The unit is undefined. A
+positive value moves the camera to the right (clockwise when viewed
+from above), a negative value to the left. A value of zero stops the motion
+if one is in progress and has no effect otherwise.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_TILT_SPEED</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control turns the
+camera vertically at the specified speed. The unit is undefined. A
+positive value moves the camera up, a negative value down. A value of zero
+stops the motion if one is in progress and has no effect otherwise.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f030d6a..4d050f9 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -796,6 +796,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
 	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
 	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
+	case V4L2_CID_PAN_SPEED:		return "Pan, Speed";
+	case V4L2_CID_TILT_SPEED:		return "Tilt, Speed";
 
 	/* FM Radio Modulator controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index e946e43..4de238b 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -746,6 +746,8 @@ enum v4l2_auto_focus_range {
 	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
 };
 
+#define V4L2_CID_PAN_SPEED			(V4L2_CID_CAMERA_CLASS_BASE+32)
+#define V4L2_CID_TILT_SPEED			(V4L2_CID_CAMERA_CLASS_BASE+33)
 
 /* FM Modulator class control IDs */
 
-- 
2.1.0.rc2.206.gedb03e5

