Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaCaDr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:47:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35221 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbaCaDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:47:24 -0400
From: Jonathan Callen <jcallen@gentoo.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Callen <jcallen@gentoo.org>
Subject: [PATCH] Documentation/java.txt: add Java 7 support
Date: Sun, 30 Mar 2014 23:47:14 -0400
Message-Id: <1396237634-6634-1-git-send-email-jcallen@gentoo.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample wrapper currently fails on some Java 7 .class files.  This
updates the wrapper to properly handle those files.

Signed-off-by: Jonathan Callen <jcallen@gentoo.org>
---
 Documentation/java.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/java.txt b/Documentation/java.txt
index e6a7232..4180205 100644
--- a/Documentation/java.txt
+++ b/Documentation/java.txt
@@ -188,6 +188,9 @@ shift
 #define CP_METHODREF 10
 #define CP_INTERFACEMETHODREF 11
 #define CP_NAMEANDTYPE 12
+#define CP_METHODHANDLE 15
+#define CP_METHODTYPE 16
+#define CP_INVOKEDYNAMIC 18
 
 /* Define some commonly used error messages */
 
@@ -242,14 +245,19 @@ void skip_constant(FILE *classfile, u_int16_t *cur)
 		break;
 	case CP_CLASS:
 	case CP_STRING:
+	case CP_METHODTYPE:
 		seekerr = fseek(classfile, 2, SEEK_CUR);
 		break;
+	case CP_METHODHANDLE:
+		seekerr = fseek(classfile, 3, SEEK_CUR);
+		break;
 	case CP_INTEGER:
 	case CP_FLOAT:
 	case CP_FIELDREF:
 	case CP_METHODREF:
 	case CP_INTERFACEMETHODREF:
 	case CP_NAMEANDTYPE:
+	case CP_INVOKEDYNAMIC:
 		seekerr = fseek(classfile, 4, SEEK_CUR);
 		break;
 	case CP_LONG:
-- 
1.9.1

