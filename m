Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3IKQjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:39:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3IKQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:39:53 -0400
Message-ID: <52309CAC.4080701@infradead.org>
Date: Wed, 11 Sep 2013 09:39:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, airlied@redhat.com,
        bskeggs@redhat.com
Subject: [PATCH] nouveau: fix build eror when VGA_SWITCHEROO is not enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix nouveau build error on x86, when ACPI is enabled but
VGA_SWITCHEROO is not enabled, by providing a stub function.

drivers/built-in.o: In function `nouveau_pmops_runtime_suspend':
nouveau_drm.c:(.text+0x3aac89): undefined reference to `nouveau_switcheroo_optimus_dsm'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130911.orig/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ linux-next-20130911/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -373,6 +373,7 @@ void nouveau_unregister_dsm_handler(void
 #else
 void nouveau_register_dsm_handler(void) {}
 void nouveau_unregister_dsm_handler(void) {}
+void nouveau_switcheroo_optimus_dsm(void) {}
 #endif
 
 /* retrieve the ROM in 4k blocks */
