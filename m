Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151AbaKLBv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:51:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116AbaKLBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:51:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.10 046/123] drm/nouveau/bios: memset dcb struct to zero before parsing
Date: Wed, 12 Nov 2014 10:16:52 +0900
Message-Id: <20141112011721.096025236@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 595d373f1e9c9ce0fc946457fdb488e8a58972cd upstream.

Fixes type/mask calculation being based on uninitialised data for VGA
outputs.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
@@ -124,6 +124,7 @@ dcb_outp_parse(struct nouveau_bios *bios
 	       struct dcb_output *outp)
 {
 	u16 dcb = dcb_outp(bios, idx, ver, len);
+	memset(outp, 0x00, sizeof(*outp));
 	if (dcb) {
 		if (*ver >= 0x20) {
 			u32 conn = nv_ro32(bios, dcb + 0x00);


