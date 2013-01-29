Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3A2Mil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:41 -0500
Received: from david.siemens.de ([192.35.17.14]:29276 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3A2Mih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:37 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 08/20] scripts/gdb: Add get_target_endianness helper
Date: Tue, 29 Jan 2013 13:37:51 +0100
Message-Id: <ce03a8cec79de39e6c4d31b57a08d65678b14737.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the target endianness from the output of "show endian" and cache
the result to return it via the new helper get_target_endiannes. We will
need it for reading integers from buffers that contain target memory.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 13f903a..1c7cb42 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -77,3 +77,20 @@ class ContainerOf(gdb.Function):
 				    elementname.string())
 
 ContainerOf()
+
+
+BIG_ENDIAN = 0
+LITTLE_ENDIAN = 1
+target_endianness = None
+
+def get_target_endianness():
+	global target_endianness
+	if target_endianness == None:
+		endian = gdb.execute("show endian", False, True)
+		if endian.find("little endian") >= 0:
+			target_endianness = LITTLE_ENDIAN
+		elif endian.find("big endian") >= 0:
+			target_endianness = BIG_ENDIAN
+		else:
+			raise gdb.GdgError("unknown endianness '%s'" % endian)
+	return target_endianness
-- 
1.7.3.4

