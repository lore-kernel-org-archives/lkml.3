Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3E1Dz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758792Ab3E1DyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rusty Russell" <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.577182416@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [50/94] virtio_console: fix uapi header
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 6407d75afd08545f2252bb39806ffd3f10c7faac upstream.

uapi should use __u32 not u32.
Fix a macro in virtio_console.h which uses u32.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/virtio_console.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -39,7 +39,7 @@
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
 
-#define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
+#define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
 
 struct virtio_console_config {
 	/* colums of the screens */

