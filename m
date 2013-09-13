Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3IMIqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:46:05 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56376 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3IMIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:46:01 -0400
From: Clement Chauplannaz <chauplac@gmail.com>
To: linus.walleij@linaro.org, mmarek@suse.cz, yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/config: fix variable substitution command
Date: Fri, 13 Sep 2013 10:45:13 +0200
Message-Id: <1379061913-17604-1-git-send-email-chauplac@gmail.com>
X-Mailer: git-send-email 1.8.3.2.dirty
In-Reply-To: <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
References: <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 229455bc02b87f7128f190c4491b4ceffff38648 accidentally changed the
separator between sed `s' command and its parameters from ':' to '/'.

Revert this change.

Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
---
 scripts/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/config b/scripts/config
index 58383e2..ae85564 100755
--- a/scripts/config
+++ b/scripts/config
@@ -80,7 +80,7 @@ txt_subst() {
 	local infile="$3"
 	local tmpfile="$infile.swp"
 
-	sed -e "s/$before/$after/" "$infile" >"$tmpfile"
+	sed -e "s:$before:$after:" "$infile" >"$tmpfile"
 	# replace original file with the edited one
 	mv "$tmpfile" "$infile"
 }
-- 
1.8.3.2.dirty

