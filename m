Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaKKQVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:21:15 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:61161 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaKKQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:21:14 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Davis <jim.epost@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next] vt: Fix build breakage when !CONFIG_VT_CONSOLE
Date: Tue, 11 Nov 2014 11:20:56 -0500
Message-Id: <1415722856-5651-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141110180929.GA13084@kroah.com>
References: <20141110180929.GA13084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 68952076e9226cc23ebce66d3fc2fdb8b6c04c30 ("vt: Remove
vt_get_kmsg_redirect() from uapi header") fails to compile if
!CONFIG_VT_CONSOLE.

Move macro definition for vt_get_kmsg_redirect() up with file-scope
function declarations.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/vt/vt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3dc5d56..ad27ade 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -156,6 +156,8 @@ static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
 static void set_palette(struct vc_data *vc);
 
+#define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
+
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
@@ -2509,8 +2511,6 @@ int vt_kmsg_redirect(int new)
 		return kmsg_con;
 }
 
-#define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
-
 /*
  *	Console on virtual terminal
  *
-- 
2.1.3

