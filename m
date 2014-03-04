Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaCDVn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:43:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaCDUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "John F. Godfrey" <jfgodfrey@gmail.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.13 005/172] drm/nouveau/fb: use correct ram oclass for nv1a hardware
Date: Tue,  4 Mar 2014 12:01:29 -0800
Message-Id: <20140304200259.882789328@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Velikov <emil.l.velikov@gmail.com>

commit 95ca5b550ac255bf3cee108c123407785c47e3cc upstream.

commit 8613e7314ac254fdd67ed46192f021d76141e4c9
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Oct 21 08:50:25 2013 +1000

    drm/nouveau/fb: remove ram oclass argument from base fb constructor

Introduced a unfortunate regression by using nv10 ram oclass for nv1a
hardware, causing corruption and eventually system lockup.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=74866
Reported-by: John F. Godfrey <jfgodfrey@gmail.com>
Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c
@@ -36,7 +36,7 @@ nv1a_fb_oclass = &(struct nv04_fb_impl)
 		.fini = _nouveau_fb_fini,
 	},
 	.base.memtype = nv04_fb_memtype_valid,
-	.base.ram = &nv10_ram_oclass,
+	.base.ram = &nv1a_ram_oclass,
 	.tile.regions = 8,
 	.tile.init = nv10_fb_tile_init,
 	.tile.fini = nv10_fb_tile_fini,


