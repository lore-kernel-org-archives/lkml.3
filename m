Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab3APQvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:51:50 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52340 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab3APQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:51:48 -0500
Date: Wed, 16 Jan 2013 17:51:44 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kvm tools: close opened file
Message-ID: <20130116165141.GA18593@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
 <20130116113522.GR11529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116113522.GR11529@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file should be closed before return.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 tools/kvm/builtin-setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/kvm/builtin-setup.c b/tools/kvm/builtin-setup.c
index c5b0566..8b45c56 100644
--- a/tools/kvm/builtin-setup.c
+++ b/tools/kvm/builtin-setup.c
@@ -159,12 +159,12 @@ static int copy_passwd(const char *guestfs_name)
 		return -1;
 
 	ret = fprintf(file, "root:x:0:0:root:/root:/bin/sh\n");
-	if (ret < 0)
-		return ret;
+	if (ret > 0)
+		ret = 0;
 
 	fclose(file);
 
-	return 0;
+	return ret;
 }
 
 static int make_guestfs_symlink(const char *guestfs_name, const char *path)
-- 
1.7.10.4

