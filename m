Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab3BYWUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab3BYWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:19:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 01/58] drm/nouveau/vm: fix memory corruption when pgt allocation fails
Date: Mon, 25 Feb 2013 14:18:57 -0800
Message-Id: <20130225221636.330542309@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit cfd376b6bfccf33782a0748a9c70f7f752f8b869 upstream.

If we return freed vm, nouveau_drm_open will happily call nouveau_cli_destroy,
which will try to free it again.

Reported-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/vm/base.c
@@ -352,7 +352,7 @@ nouveau_vm_create(struct nouveau_vmmgr *
 	u64 mm_length = (offset + length) - mm_offset;
 	int ret;
 
-	vm = *pvm = kzalloc(sizeof(*vm), GFP_KERNEL);
+	vm = kzalloc(sizeof(*vm), GFP_KERNEL);
 	if (!vm)
 		return -ENOMEM;
 
@@ -376,6 +376,8 @@ nouveau_vm_create(struct nouveau_vmmgr *
 		return ret;
 	}
 
+	*pvm = vm;
+
 	return 0;
 }
 


