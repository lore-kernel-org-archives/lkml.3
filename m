Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaIZKOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:14:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaIZJqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/142] RDMA/uapi: Include socket.h in rdma_user_cm.h
Date: Fri, 26 Sep 2014 11:45:09 +0200
Message-Id: <d1079a21adf42e46f4f05defa545b38ad4bf6675.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Ledford <dledford@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit db1044d458a287c18c4d413adc4ad12e92e253b5 upstream.

added struct sockaddr_storage to rdma_user_cm.h without also adding an
include for linux/socket.h to make sure it is defined.  Systemtap
needs the header files to build standalone and cannot rely on other
files to pre-include other headers, so add linux/socket.h to the list
of includes in this file.

Fixes: ee7aed4528f ("RDMA/ucma: Support querying for AF_IB addresses")
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/rdma/rdma_user_cm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 99b80abf360a..3066718eb120 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -34,6 +34,7 @@
 #define RDMA_USER_CM_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
 #include <linux/in6.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_user_sa.h>
-- 
2.1.0

