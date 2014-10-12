Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJLPx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 11:53:27 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53042 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaJLPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 11:53:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Liang Zhen <liang.zhen@intel.com>,
        Denis Pithon <denis.pithon@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, Patrick Farrell <paf@cray.com>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: ptlrpc: sec.c:  Replacing strncat with strlcat to avoid overwrite size
Date: Sun, 12 Oct 2014 17:55:33 +0200
Message-Id: <1413129333-19863-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat with strlcat to avoid overwrite the max size.
Take the opportunity to change a snprint to strlcpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/ptlrpc/sec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 5cff7ee..d276e98 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -209,7 +209,7 @@ EXPORT_SYMBOL(sptlrpc_flavor2name_bulk);
 
 char *sptlrpc_flavor2name(struct sptlrpc_flavor *sf, char *buf, int bufsize)
 {
-	snprintf(buf, bufsize, "%s", sptlrpc_flavor2name_base(sf->sf_rpc));
+	strlcpy(buf, sptlrpc_flavor2name_base(sf->sf_rpc), bufsize);
 
 	/*
 	 * currently we don't support customized bulk specification for
@@ -220,10 +220,9 @@ char *sptlrpc_flavor2name(struct sptlrpc_flavor *sf, char *buf, int bufsize)
 
 		bspec[0] = '-';
 		sptlrpc_flavor2name_bulk(sf, &bspec[1], sizeof(bspec) - 1);
-		strncat(buf, bspec, bufsize);
+		strlcat(buf, bspec, bufsize);
 	}
 
-	buf[bufsize - 1] = '\0';
 	return buf;
 }
 EXPORT_SYMBOL(sptlrpc_flavor2name);
-- 
1.7.10.4

