Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3BZGj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:39:26 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:53396 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432Ab3BZGjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:39:23 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/8] v4l2: Add documentation for the FM RX controls
Date: Mon, 25 Feb 2013 22:38:52 -0800
Message-Id: <1361860734-21666-7-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add appropriate documentation for all the newly added standard
controls.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   72 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   11 ++-
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 104a1a2..f418bc3 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2310,6 +2310,9 @@ more information.</para>
 	<listitem>
 	  <para>Added FM Modulator (FM TX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_TX</constant> and their Control IDs.</para>
 	</listitem>
+<listitem>
+	  <para>Added FM Receiver (FM RX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_RX</constant> and their Control IDs.</para>
+	</listitem>
 	<listitem>
 	  <para>Added Remote Controller chapter, describing the default Remote Controller mapping for media devices.</para>
 	</listitem>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e8f854..e8fe005 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4687,4 +4687,76 @@ interface and may change in the future.</para>
       </table>
 
     </section>
+
+    <section id="fm-rx-controls">
+      <title>FM Receiver Control Reference</title>
+
+      <para>The FM Receiver (FM_RX) class includes controls for common features of
+      FM Reception capable devices.</para>
+
+      <table pgwide="1" frame="none" id="fm-rx-control-id">
+      <title>FM_RX Control IDs</title>
+
+      <tgroup cols="4">
+        <colspec colname="c1" colwidth="1*" />
+        <colspec colname="c2" colwidth="6*" />
+        <colspec colname="c3" colwidth="2*" />
+        <colspec colname="c4" colwidth="6*" />
+        <spanspec namest="c1" nameend="c2" spanname="id" />
+        <spanspec namest="c2" nameend="c4" spanname="descr" />
+        <thead>
+          <row>
+            <entry spanname="id" align="left">ID</entry>
+            <entry align="left">Type</entry>
+          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+          </row>
+        </thead>
+        <tbody valign="top">
+          <row><entry></entry></row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_FM_RX_CLASS</constant>&nbsp;</entry>
+            <entry>class</entry>
+          </row><row><entry spanname="descr">The FM_RX class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+          </row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_RDS_RECEPTION</constant>&nbsp;</entry>
+            <entry>boolean</entry>
+          </row><row><entry spanname="descr">Enables/disables RDS
+	  reception by the radio tuner</entry>
+          </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_TUNE_DEEMPHASIS</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row id="v4l2-deemphasis"><entry spanname="descr">Configures the de-emphasis value for reception.
+A de-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
+Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_emphasis
+defines possible values for de-emphasis. Here they are:</entry>
+	</row><row>
+	<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
+		      <entry>No de-emphasis is applied.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
+		      <entry>A de-emphasis of 50 uS is used.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
+		      <entry>A de-emphasis of 75 uS is used.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+
+	  </row>
+          <row><entry></entry></row>
+        </tbody>
+      </tgroup>
+      </table>
+
+      </section>
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 4e16112..b03a57b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -9,7 +9,7 @@ VIDIOC_TRY_EXT_CTRLS</refentrytitle>
     <refname>VIDIOC_G_EXT_CTRLS</refname>
     <refname>VIDIOC_S_EXT_CTRLS</refname>
     <refname>VIDIOC_TRY_EXT_CTRLS</refname>
-    <refpurpose>Get or set the value of several controls, try control
+   <refpurpose>Get or set the value of several controls, try control
 values</refpurpose>
   </refnamediv>
 
@@ -319,6 +319,15 @@ These controls are described in <xref
 	    processing controls. These controls are described in <xref
 	    linkend="image-process-controls" />.</entry>
 	  </row>
+
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_FM_RX</constant></entry>
+	    <entry>0xa10000</entry>
+	    <entry>The class containing FM Receiver (FM RX) controls.
+These controls are described in <xref
+		linkend="fm-rx-controls" />.</entry>
+	  </row>
+
 	</tbody>
       </tgroup>
     </table>
-- 
1.7.10.4

