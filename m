Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3CVKVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:21:44 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60141 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3CVKVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:21:42 -0400
From: Anisse Astier <anisse@astier.eu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, maximilian attems <max@stro.at>,
        Anisse Astier <anisse@astier.eu>
Subject: [PATCH 2/2] deb-pkg: add a hook argument to match debian hooks parameters
Date: Fri, 22 Mar 2013 11:06:01 +0100
Message-Id: <1363946761-7449-2-git-send-email-anisse@astier.eu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363946761-7449-1-git-send-email-anisse@astier.eu>
References: <1363946761-7449-1-git-send-email-anisse@astier.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should allow the package to better integrate with debian hooks, and
should not be too disruptive of hooks supporting only one parameter.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
 scripts/package/builddeb | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 7f7a7fd..30d8756 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -169,7 +169,7 @@ set -e
 # Pass maintainer script parameters to hook scripts
 export DEB_MAINT_PARAMS="\$*"
 
-test -d $debhookdir/$script.d && run-parts --arg="$version" $debhookdir/$script.d
+test -d $debhookdir/$script.d && run-parts --arg="$version" --arg="/boot/vmlinuz-$version" $debhookdir/$script.d
 exit 0
 EOF
 	chmod 755 "$tmpdir/DEBIAN/$script"
-- 
1.8.1.4

