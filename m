Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaHOL7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:59:17 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45319 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaHOL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:59:16 -0400
Date: Fri, 15 Aug 2014 13:59:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] s390: pass march flag to assembly files as well
Message-ID: <20140815115910.GB4215@osiris>
References: <20140703120046.GA10664@suse.cz>
 <20140708080740.GA4491@osiris>
 <20140815115753.GA4215@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815115753.GA4215@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081511-5024-0000-0000-000000FF35C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the march flag gets only passed to C files, but not to
assembler files.
This means that we can't add new instructions like e.g. aghik to asm
files, since the assembler doesn't know of the new instructions if
the appropriate march flag isn't specified.

So also pass the march flag when compiling assembler files as well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Makefile | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 874e6d6e9c5f..878e67973151 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -35,13 +35,16 @@ endif
 
 export LD_BFD
 
-cflags-$(CONFIG_MARCH_G5)     += -march=g5
-cflags-$(CONFIG_MARCH_Z900)   += -march=z900
-cflags-$(CONFIG_MARCH_Z990)   += -march=z990
-cflags-$(CONFIG_MARCH_Z9_109) += -march=z9-109
-cflags-$(CONFIG_MARCH_Z10)    += -march=z10
-cflags-$(CONFIG_MARCH_Z196)   += -march=z196
-cflags-$(CONFIG_MARCH_ZEC12)  += -march=zEC12
+mflags-$(CONFIG_MARCH_G5)     := -march=g5
+mflags-$(CONFIG_MARCH_Z900)   := -march=z900
+mflags-$(CONFIG_MARCH_Z990)   := -march=z990
+mflags-$(CONFIG_MARCH_Z9_109) := -march=z9-109
+mflags-$(CONFIG_MARCH_Z10)    := -march=z10
+mflags-$(CONFIG_MARCH_Z196)   := -march=z196
+mflags-$(CONFIG_MARCH_ZEC12)  := -march=zEC12
+
+aflags-y += $(mflags-y)
+cflags-y += $(mflags-y)
 
 cflags-$(CONFIG_MARCH_G5_TUNE)		+= -mtune=g5
 cflags-$(CONFIG_MARCH_Z900_TUNE)	+= -mtune=z900
-- 
1.8.5.5

