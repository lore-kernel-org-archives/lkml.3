Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaKNFWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:22:47 -0500
Received: from karr.yath.de ([144.76.4.50]:57436 "EHLO karr.yath.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaKNFWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:22:46 -0500
X-Greylist: delayed 779 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 00:22:45 EST
Date: Thu, 13 Nov 2014 21:22:39 -0800
From: Sebastian Schmidt <yath@yath.de>
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] syslog: provide stub check_syslog_permissions
Message-ID: <20141114052239.GB7964@moniac.lan.yath.de>
References: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
 <CAGXu5jLsd3G3+PCwFSUGDxxbfnJwx8G8X4chH0WK21-kv+_ecA@mail.gmail.com>
 <20141114050934.GA7964@moniac.lan.yath.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114050934.GA7964@moniac.lan.yath.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building without CONFIG_PRINTK, we need to provide a stub
check_syslog_permissions. As there is no way to turn on the
dmesg_restrict sysctl without CONFIG_PRINTK, return success.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Sebastian Schmidt <yath@yath.de>
---
 include/linux/syslog.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 9def529..13c05d1 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -48,6 +48,14 @@
 #define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
+
+#ifdef CONFIG_PRINTK
 int check_syslog_permissions(int type, bool from_file);
+#else
+static int check_syslog_permissions(int type, bool from_file)
+{
+	return 0;
+}
+#endif
 
 #endif /* _LINUX_SYSLOG_H */
-- 
2.1.1
