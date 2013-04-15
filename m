Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab3DOFQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:16:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23244 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3DOFQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:16:00 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        virtualization@lists.linux-foundation.org,
        v9fs-developer@lists.sourceforge.net,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] virtio-spec: document virtio-9p
Date: Mon, 15 Apr 2013 01:13:48 -0400
Message-Id: <1366002828-30037-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic documentation for virtio-9p. I can expand more on device operation,
but I don't think there's anything significant enough for the spec to be
mentioned there. Please let me know if I'm wrong.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 virtio-spec.lyx | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index c23a345..73a0567 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -57,6 +57,7 @@
 \html_css_as_file 0
 \html_be_strict false
 \author -1930653948 "Amos Kong" 
+\author -1728740334 "Sasha Levin" sasha.levin@oracle.com
 \author -875410574 "Pawel Moll" 
 \author -608949062 "Rusty Russell,,," 
 \author -385801441 "Cornelia Huck" cornelia.huck@de.ibm.com
@@ -619,7 +620,13 @@ Appendix I
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted -1728740334 1365526571
+Appendix J
+\change_deleted -1728740334 1365526568
 -
+\change_unchanged
+
 \end_layout
 
 \end_inset
@@ -9678,6 +9685,204 @@ For MMC devices (inquiry type 5) there would be some overlap between this
 \end_layout
 
 \end_deeper
+\end_deeper
+\begin_layout Chapter*
+
+\change_inserted -1728740334 1365526640
+Appendix J: 9p Transport
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1728740334 1365526873
+The virtio transport for 9p provides an interface to transfer 9p messages
+ between the device and the driver.
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted -1728740334 1365526612
+Configuration
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1728740334 1365526876
+Subsystem
+\begin_inset space ~
+\end_inset
+
+Device
+\begin_inset space ~
+\end_inset
+
+ID 9
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1728740334 1365526891
+Virtqueues 0:requests.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1728740334 1365527214
+Feature
+\begin_inset space ~
+\end_inset
+
+bits
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+
+\change_inserted -1728740334 1365529363
+VIRTIO_9P_MOUNT_TAG(0) The mount point is specified in the device configuration.
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted -1728740334 1365527300
+Device
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+layout Both fields of this configuration are available only if VIRTIO_9P_MOUNT_T
+AG was negotiated:
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527046
+
+struct virtio_9p_config {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527050
+
+	/* length of the tag name */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527055
+
+	__u16 tag_len;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527056
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527065
+
+	/* non-NULL terminated tag name */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527072
+
+	__u8 tag[0];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1728740334 1365527072
+
+} __attribute__((packed));
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+
+\change_inserted -1728740334 1365527670
+tag_len is the length of the mount tag string.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1728740334 1365527700
+tag is the name of the moung tag.
+ The tag should not be terminated by NULL.
+\end_layout
+
+\end_deeper
+\begin_layout Section*
+
+\change_inserted -1728740334 1365526612
+Device Initialization
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted -1728740334 1365527786
+The requests virtqueue is initialized.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted -1728740334 1365527828
+If VIRTIO_9P_MOUNT_TAG was negotiated:
+\end_layout
+
+\begin_deeper
+\begin_layout Enumerate
+
+\change_inserted -1728740334 1365527872
+the tag_len field is read from the configuration to acertain the length
+ of the mount tag.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted -1728740334 1365527876
+tag_len bytes are read from the tag field and are used as the name of the
+ mount tag.
+\end_layout
+
+\end_deeper
+\begin_layout Enumerate
+
+\change_inserted -1728740334 1365527948
+The device is now ready to process requests.
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted -1728740334 1365526612
+Device Operation
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1728740334 1365529176
+When the driver wantes to send a 9P request it places the descriptor of
+ the PDU in the queue.
+ It will be processed by the device according to the 9P protocol specifications
+ (available at http://ericvh.github.io/9p-rfc/) and returned to the driver.
+\end_layout
+
 \begin_layout Chapter*
 Appendix X: virtio-mmio
 \end_layout
-- 
1.8.1.5

