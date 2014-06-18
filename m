Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967146AbaFRO0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:26:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966809AbaFRO0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:26:31 -0400
From: Michal Marek <mmarek@suse.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix tar-pkg with relative $(objtree)
Date: Wed, 18 Jun 2014 16:26:23 +0200
Message-Id: <1403101583-15275-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140617223854.GC6168@fieldses.org>
References: <20140617223854.GC6168@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7e1c0477 (kbuild: Use relative path for $(objtree)) assumes that
the build process does not change its working directory. make tar-pkg
was a couterexample, fix this by changing directory only for the tar
command and not for the whole script, which at one point references the
now relative $(objtree).

Reported-by: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/buildtar | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 995c1ea..e046bff 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -125,12 +125,11 @@ esac
 # Create the tarball
 #
 (
-	cd "${tmpdir}"
 	opts=
 	if tar --owner=root --group=root --help >/dev/null 2>&1; then
 		opts="--owner=root --group=root"
 	fi
-	tar cf - boot/* lib/* $opts | ${compress} > "${tarball}${file_ext}"
+	tar cf - -C "$tmpdir" boot/ lib/ $opts | ${compress} > "${tarball}${file_ext}"
 )
 
 echo "Tarball successfully created in ${tarball}${file_ext}"
-- 
1.9.2

