Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaLUWlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:41:07 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47675 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaLUWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:41:06 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: include: lustre_update.h:  Fix for possible null pointer dereference
Date: Sun, 21 Dec 2014 23:43:51 +0100
Message-Id: <1419201831-13878-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NULL check was done to late, and there it was a risk
of a possible null pointer dereference.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/include/lustre_update.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_update.h b/drivers/staging/lustre/lustre/include/lustre_update.h
index 84defce..00e1361 100644
--- a/drivers/staging/lustre/lustre/include/lustre_update.h
+++ b/drivers/staging/lustre/lustre/include/lustre_update.h
@@ -165,12 +165,14 @@ static inline int update_get_reply_buf(struct update_reply *reply, void **buf,
 	int  result;
 
 	ptr = update_get_buf_internal(reply, index, &size);
+
+	LASSERT((ptr != NULL && size >= sizeof(int)));
+
 	result = *(int *)ptr;
 
 	if (result < 0)
 		return result;
 
-	LASSERT((ptr != NULL && size >= sizeof(int)));
 	*buf = ptr + sizeof(int);
 	return size - sizeof(int);
 }
-- 
1.7.10.4

