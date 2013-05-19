Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3ESNWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3ESNWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:22:16 -0400
Date: Sun, 19 May 2013 16:22:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] virtio_pci: better macro exported in uapi
Message-ID: <20130519132224.GA23858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro VIRTIO_PCI_CONFIG assumes that userspace actually has a structure
with a field named msix_enabled.  Add VIRTIO_PCI_CONFIG_OFF that gets
the msix_enabled by value instead, to make it useful for userspace.  We
still keep VIRTIO_PCI_CONFIG around for now, in case some userspace uses
it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Changes from v1:
- rename macro to VIRTIO_PCI_CONFIG_OFF so preprocessor
  can be used to check for its presence, as suggested
  by Rusty
- keep old macro around as suggested by David Howells

 include/uapi/linux/virtio_pci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index ea66f3f..e5ec1ca 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -80,7 +80,9 @@
 
 /* The remaining space is defined by each driver as the per-driver
  * configuration space */
-#define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
+#define VIRTIO_PCI_CONFIG_OFF(msix_enabled)	((msix_enabled) ? 24 : 20)
+/* Deprecated: please use VIRTIO_PCI_CONFIG_OFF instead */
+#define VIRTIO_PCI_CONFIG(dev)	VIRTIO_PCI_CONFIG_OFF((dev)->msix_enabled)
 
 /* Virtio ABI version, this must match exactly */
 #define VIRTIO_PCI_ABI_VERSION		0
-- 
MST
