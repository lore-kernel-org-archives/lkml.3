Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3C0Ctt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:49:49 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:44368 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3C0Cry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:47:54 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: mchehab@redhat.com
Cc: andrew.smirnov@gmail.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 7/9] v4l2: Add documentation for the FM RX controls
Date: Tue, 26 Mar 2013 19:47:24 -0700
Message-Id: <1364352446-28572-8-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
References: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add appropriate documentation for all the newly added standard
controls.

Based on the patch by Manjunatha Halli [1]

[1] http://lists-archives.com/linux-kernel/27641303-media-update-docs-for-v4l2-fm-new-features.html

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   72 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    9 +++
 3 files changed, 84 insertions(+)

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
index 1ad20cc..6aa647a 100644
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
+	    <entry>enum v4l2_deemphasis</entry>
+	  </row>
+	  <row id="v4l2-deemphasis"><entry spanname="descr">Configures the de-emphasis value for reception.
+A de-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
+Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_deemphasis
+defines possible values for de-emphasis. Here they are:</entry>
+	</row><row>
+	<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_DEEMPHASIS_DISABLED</constant>&nbsp;</entry>
+		      <entry>No de-emphasis is applied.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_DEEMPHASIS_50_uS</constant>&nbsp;</entry>
+		      <entry>A de-emphasis of 50 uS is used.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_DEEMPHASIS_75_uS</constant>&nbsp;</entry>
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
index 4e16112..b3bb957 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
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

