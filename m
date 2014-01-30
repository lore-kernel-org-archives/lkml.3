Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaA3RtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:49:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaA3RtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:49:02 -0500
Date: Thu, 30 Jan 2014 12:48:51 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: andreas.dilger@intel.com, gregkh@linuxfoundation.org
Subject: lustre: remove unnecessary 'magic' from lustre_pack_request
Message-ID: <20140130174851.GC1834@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	andreas.dilger@intel.com, gregkh@linuxfoundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This probably made more sense when the code supported multiple protocol versions,
but now it's just obfuscation.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 464479c0f00b..c319f74b04f6 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -244,15 +244,7 @@ int lustre_pack_request(struct ptlrpc_request *req, __u32 magic, int count,
 	LASSERT(lens[MSG_PTLRPC_BODY_OFF] == sizeof(struct ptlrpc_body));
 
 	/* only use new format, we don't need to be compatible with 1.4 */
-	magic = LUSTRE_MSG_MAGIC_V2;
-
-	switch (magic) {
-	case LUSTRE_MSG_MAGIC_V2:
-		return lustre_pack_request_v2(req, count, lens, bufs);
-	default:
-		LASSERTF(0, "incorrect message magic: %08x\n", magic);
-		return -EINVAL;
-	}
+	return lustre_pack_request_v2(req, count, lens, bufs);
 }
 EXPORT_SYMBOL(lustre_pack_request);
 
