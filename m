Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaCDUCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaCDUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torsten Wagner <torsten.wagner@gmail.com>,
        Michael Gulick <mgulick@mathworks.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.13 006/172] drm/nv50/disp: use correct register to determine DP display bpp
Date: Tue,  4 Mar 2014 12:01:30 -0800
Message-Id: <20140304200259.910397774@linuxfoundation.org>
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

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit a7f1c1e65b68e1e1ab70898528d5977ed68a0a7d upstream.

Commit 0a0afd282f ("drm/nv50-/disp: move DP link training to core and
train from supervisor") added code that uses the wrong register for
computing the display bpp, used for bandwidth calculation. Adjust to use
the same register as used by exec_clkcmp and nv50_disp_intr_unk20_2_dp.

Reported-by: Torsten Wagner <torsten.wagner@gmail.com>
Reported-by: Michael Gulick <mgulick@mathworks.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67628
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
@@ -1112,7 +1112,7 @@ nv50_disp_intr_unk20_2(struct nv50_disp_
 	if (conf != ~0) {
 		if (outp.location == 0 && outp.type == DCB_OUTPUT_DP) {
 			u32 soff = (ffs(outp.or) - 1) * 0x08;
-			u32 ctrl = nv_rd32(priv, 0x610798 + soff);
+			u32 ctrl = nv_rd32(priv, 0x610794 + soff);
 			u32 datarate;
 
 			switch ((ctrl & 0x000f0000) >> 16) {


