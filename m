Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968069Ab3E3J4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:56:22 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39132 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967560Ab3E3J4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:56:17 -0400
MIME-Version: 1.0
From: Jonathan Salwan <jonathan.salwan@gmail.com>
Date: Thu, 30 May 2013 11:55:45 +0200
Message-ID: <CAEmQOhDAsSKkL2pofEWy_D_02uNG4=NE4hYi20etV7kF5OqfOw@mail.gmail.com>
Subject: [PATCH] vmwgfx : Fix potential NULL pointer dereference in vmw_surface_define_ioctl()
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In ./drivers/gpu/drm/vmwgfx/vmwgfx_surface.c line 735 isn't
'srf->sizes' but 'srf->offsets' which need to be checked.


diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 5828143..02da0ee 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -732,7 +732,7 @@ int vmw_surface_define_ioctl(struct drm_device
*dev, void *data,
        }
        srf->offsets = kmalloc(srf->num_sizes * sizeof(*srf->offsets),
                               GFP_KERNEL);
-       if (unlikely(srf->sizes == NULL)) {
+       if (unlikely(srf->offsets == NULL)) {
                ret = -ENOMEM;
                goto out_no_offsets;
        }


Regards,

--
Jonathan Salwan
