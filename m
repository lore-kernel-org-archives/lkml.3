Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab3FSSmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:42:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935123Ab3FSSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:19 -0400
Date: Wed, 19 Jun 2013 11:42:02 -0700
From: tip-bot for Jiri Slaby <tipbot@zytor.com>
Message-ID: <tip-062f487190c8126209391ccb720a4ec943fd4a57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, jslaby@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jslaby@suse.cz
In-Reply-To: <1371628383-11216-1-git-send-email-jslaby@suse.cz>
References: <1371628383-11216-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/boot: Close opened file descriptor
Git-Commit-ID: 062f487190c8126209391ccb720a4ec943fd4a57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:42:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  062f487190c8126209391ccb720a4ec943fd4a57
Gitweb:     http://git.kernel.org/tip/062f487190c8126209391ccb720a4ec943fd4a57
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Wed, 19 Jun 2013 09:53:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 13:32:19 +0200

x86/boot: Close opened file descriptor

During build we open a file, read that but do not close it. Fix
that by sticking fclose() at the right place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: http://lkml.kernel.org/r/1371628383-11216-1-git-send-email-jslaby@suse.cz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/boot/tools/build.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 94c5446..c941d6a 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -243,6 +243,7 @@ static void parse_zoffset(char *fname)
 	c = fread(buf, 1, sizeof(buf) - 1, file);
 	if (ferror(file))
 		die("read-error on `zoffset.h'");
+	fclose(file);
 	buf[c] = 0;
 
 	p = (char *)buf;
