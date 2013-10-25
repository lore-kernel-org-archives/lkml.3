Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3JYNOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:14:51 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41000 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab3JYNOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:14:50 -0400
Date: Fri, 25 Oct 2013 06:14:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: replace unbounded sprintf call in modpost
Message-ID: <20131025131443.GA7759@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modpost tool could overflow its stack buffer if someone was running
with an insane shell environment. Regardless, it's technically a bug,
so this fixes it to truncate the string instead of seg-faulting.

Found by Coverity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/mod/sumversion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 9dfcd6d988da..deb2994b04c4 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -416,7 +416,7 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 		basename = strrchr(modname, '/') + 1;
 	else
 		basename = modname;
-	sprintf(filelist, "%s/%.*s.mod", modverdir,
+	snprintf(filelist, sizeof(filelist), "%s/%.*s.mod", modverdir,
 		(int) strlen(basename) - 2, basename);
 
 	file = grab_file(filelist, &len);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
