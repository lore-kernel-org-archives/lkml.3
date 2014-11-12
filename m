Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaKLBYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaKLBXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.17 088/319] drm/cirrus: bind also to qemu-xen-traditional
Date: Wed, 12 Nov 2014 10:13:46 +0900
Message-Id: <20141112011007.150144164@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit c0c3e735fa7bae29c6623511127fd021b2d6d849 upstream.

qemu as used by xend/xm toolstack uses a different subvendor id.
Bind the drm driver also to this emulated card.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/cirrus/cirrus_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -32,6 +32,8 @@ static struct drm_driver driver;
 static const struct pci_device_id pciidlist[] = {
 	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
 	  0, 0 },
+	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
+	  0x0001, 0, 0, 0 },
 	{0,}
 };
 


