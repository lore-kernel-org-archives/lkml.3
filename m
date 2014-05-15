Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaEOUyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:54:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEOUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:54:53 -0400
Message-ID: <5375299C.5040706@infradead.org>
Date: Thu, 15 May 2014 13:54:52 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jonathan Callen <jcallen@gentoo.org>
Subject: [PATCH 3/4] Documentation: update java sample wrapper for java 7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Jonathan Callen <jcallen@gentoo.org>

The sample wrapper currently fails on some Java 7 .class files.  This
updates the wrapper to properly handle those files.

Signed-off-by: Jonathan Callen <jcallen@gentoo.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/java.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

--- lnx-315-rc2.orig/Documentation/java.txt
+++ lnx-315-rc2/Documentation/java.txt
@@ -188,6 +188,9 @@ shift
 #define CP_METHODREF 10
 #define CP_INTERFACEMETHODREF 11
 #define CP_NAMEANDTYPE 12
+#define CP_METHODHANDLE 15
+#define CP_METHODTYPE 16
+#define CP_INVOKEDYNAMIC 18
 
 /* Define some commonly used error messages */
 
@@ -242,14 +245,19 @@ void skip_constant(FILE *classfile, u_in
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
