Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaCKU0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:26:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35167 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbaCKU0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:26:14 -0400
Date: Tue, 11 Mar 2014 13:25:53 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Sean Young <sean@mess.org>, Juergen Lock <nox@jelal.kn-bremen.de>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: rc-core: use %s in rc_map_get() module load
Message-ID: <20140311202553.GA24552@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rc_map_get() takes a single string literal for the module to load,
so make sure it cannot be used as a format string in the call to
request_module().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
On another security note, this raw request_module() call should have
some kind of prefix associated with it to make sure it can't be used to
load arbitrary modules. For example, request_module("probe-%s", name)
or something, as done for crypto, binfmts, etc.
---
 drivers/media/rc/rc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 02e2f38c9c85..dca97aa0a51e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -62,7 +62,7 @@ struct rc_map *rc_map_get(const char *name)
 	map = seek_rc_map(name);
 #ifdef MODULE
 	if (!map) {
-		int rc = request_module(name);
+		int rc = request_module("%s", name);
 		if (rc < 0) {
 			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
 			return NULL;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
