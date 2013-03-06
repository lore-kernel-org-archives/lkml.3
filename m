Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3CFIFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:05:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab3CFIFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:05:52 -0500
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] buildtar: Add ARCH to the archive name
Date: Wed,  6 Mar 2013 09:05:47 +0100
Message-Id: <1362557147-14393-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

When dealing with multiple sub-arches (like 32- and 64-bit on x86, for
example) generating a bunch of kernel tar archives with the same name
but for different sub-arches could get confusing and error-prone. Also,
the build process could overwrite otherwise unrelated builds and you
probably don't want that. So, add the architecture to the archive name
for more clarity and less shoot-yourself-in-the-foot practices.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 scripts/package/buildtar | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 62d8234f8787..cdd9bb909bcd 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -16,7 +16,7 @@ set -e
 # Some variables and settings used throughout the script
 #
 tmpdir="${objtree}/tar-install"
-tarball="${objtree}/linux-${KERNELRELEASE}.tar"
+tarball="${objtree}/linux-${KERNELRELEASE}-${ARCH}.tar"
 
 
 #
-- 
1.8.1.3.535.ga923c31

