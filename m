Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaGGXyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaGGXyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.14 36/94] drm/gk208/gr: add missing registers to grctx init
Date: Mon,  7 Jul 2014 16:57:26 -0700
Message-Id: <20140707235757.848576500@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 255b329ca7f0e9b5fa6da3a68bb713684fe10305 upstream.

This fixes hangs on GK208 which happen instantaneously on trying to use a
geometry shader.

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c
@@ -1318,10 +1318,12 @@ nv108_grctx_generate_mods(struct nvc0_gr
 	mmio_list(0x408010, 0x80000000,  0, 0);
 	mmio_list(0x419004, 0x00000000,  8, 1);
 	mmio_list(0x419008, 0x00000000,  0, 0);
+	mmio_list(0x4064cc, 0x80000000,  0, 0);
 	mmio_list(0x408004, 0x00000000,  8, 0);
 	mmio_list(0x408008, 0x80000030,  0, 0);
 	mmio_list(0x418808, 0x00000000,  8, 0);
 	mmio_list(0x41880c, 0x80000030,  0, 0);
+	mmio_list(0x4064c8, 0x00c20200,  0, 0);
 	mmio_list(0x418810, 0x80000000, 12, 2);
 	mmio_list(0x419848, 0x10000000, 12, 2);
 


