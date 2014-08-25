Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaHYKZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:25:50 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57106 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaHYKZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:25:35 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] modpost: simplify file name generation of *.mod.c files
Date: Mon, 25 Aug 2014 12:25:16 +0200
Message-Id: <1408962316-19921-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408962316-19921-1-git-send-email-minipli@googlemail.com>
References: <1408962316-19921-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the variable length array (vla), just use PATH_MAX instead.
This not only makes this code clang friedly, it also leads to a
code size reduction:

   text    data     bss     dec     hex filename
  51765    2224   12416   66405   10365 scripts/mod/modpost.old
  51677    2224   12416   66317   1030d scripts/mod/modpost.new

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c2ebdc788f..3b405c726e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2212,7 +2212,7 @@ int main(int argc, char **argv)
 	err = 0;
 
 	for (mod = modules; mod; mod = mod->next) {
-		char fname[strlen(mod->name) + 10];
+		char fname[PATH_MAX];
 
 		if (mod->skip)
 			continue;
-- 
1.7.10.4

