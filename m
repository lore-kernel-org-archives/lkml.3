Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab3BNKya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:54:30 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56257 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3BNKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:54:29 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] virtio-spec: Define virtio-mmio registers as LE
Date: Thu, 14 Feb 2013 10:54:06 +0000
Message-Id: <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <87wqubkalj.fsf@rustcorp.com.au>
References: <87wqubkalj.fsf@rustcorp.com.au>
X-OriginalArrivalTime: 14 Feb 2013 10:54:26.0273 (UTC) FILETIME=[A7DEC510:01CE0AA1]
X-MC-Unique: 113021410542701101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1EAsWUd003931

To solve the never-ending confusions between hosts and guests
of different endianess, define all virtio-mmio registers as LE.

This change should be safe at this stage, because no known
working mixed-endian system exists so there is virtually no
risk of breaking compatibility.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 virtio-spec.lyx |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index 1ba9992..a00b675 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -56,6 +56,7 @@
 \html_math_output 0
 \html_css_as_file 0
 \html_be_strict false
+\author -875410574 "Pawel Moll" 
 \author -608949062 "Rusty Russell,,," 
 \author -385801441 "Cornelia Huck" cornelia.huck@de.ibm.com
 \author 1112500848 "Rusty Russell" rusty@rustcorp.com.au
@@ -1850,6 +1851,17 @@ struct vring {
 
 \begin_layout Subsection
 A Note on Virtqueue Endianness
+\change_inserted -875410574 1360838374
+
+\begin_inset CommandInset label
+LatexCommand label
+name "sub:Virtqueue-Endianness"
+
+\end_inset
+
+
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
@@ -9850,8 +9862,24 @@ a
 \end_layout
 
 \begin_layout Standard
+
+\change_deleted -875410574 1360838214
 The endianness of the registers follows the native endianness of the Guest.
- Writing to registers described as 
+\change_inserted -875410574 1360838930
+All register values are organized as Little Endian, similarly to the PCI
+ variant, see also 
+\begin_inset CommandInset ref
+LatexCommand ref
+reference "sub:Virtqueue-Endianness"
+
+\end_inset
+
+.
+ 
+\change_deleted -875410574 1360838262
+ 
+\change_unchanged
+Writing to registers described as 
 \begin_inset Quotes eld
 \end_inset
 
-- 
1.7.10.4


