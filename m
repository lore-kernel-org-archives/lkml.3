Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3EIXPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:15:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3EIW0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 08/73] remoteproc: fix kconfig dependencies for VIRTIO
Date: Thu,  9 May 2013 15:24:58 -0700
Message-Id: <20130509222527.363345157@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit b9777859ec015a78dae1476e317d04f851bfdd0d upstream.

Fix this:

warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)

Signed-off-by: Suman Anna <s-anna@ti.com>
[edit commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -6,6 +6,7 @@ config REMOTEPROC
 	depends on HAS_DMA
 	select FW_LOADER
 	select VIRTIO
+	select VIRTUALIZATION
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"


