Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3LRL54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:57:56 -0500
Received: from mx0.aculab.com ([213.249.233.131]:60917 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753375Ab3LRL5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:57:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] Add .PHONY for the phony targets
Date: Wed, 18 Dec 2013 11:56:23 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74A8@saturn3.aculab.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add .PHONY for the phony targets
Thread-Index: Ac776CzQfMG305YVTkqJZcyK+Le/MQ==
From: "David Laight" <David.Laight@ACULAB.COM>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark all the phony targets .PHONY otherwise the targets aren't built
it a local file of the same name exists.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 arch/x86/boot/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 379814b..bba5ae9 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -129,6 +129,7 @@ $(obj)/mtools.conf: $(src)/mtools.conf.in
 	sed -e 's|@OBJ@|$(obj)|g' < $< > $@
 
 # This requires write access to /dev/fd0
+.PHONY: bzdisk
 bzdisk: $(obj)/bzImage $(obj)/mtools.conf
 	MTOOLSRC=$(obj)/mtools.conf mformat a:			; sync
 	syslinux /dev/fd0					; sync
@@ -140,6 +141,7 @@ bzdisk: $(obj)/bzImage $(obj)/mtools.conf
 	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage a:linux	; sync
 
 # These require being root or having syslinux 2.02 or higher installed
+.PHONY: fdimage fdimage144
 fdimage fdimage144: $(obj)/bzImage $(obj)/mtools.conf
 	dd if=/dev/zero of=$(obj)/fdimage bs=1024 count=1440
 	MTOOLSRC=$(obj)/mtools.conf mformat v:			; sync
@@ -151,6 +153,7 @@ fdimage fdimage144: $(obj)/bzImage $(obj)/mtools.conf
 	fi
 	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage v:linux	; sync
 
+.PHONY: fdimage288
 fdimage288: $(obj)/bzImage $(obj)/mtools.conf
 	dd if=/dev/zero of=$(obj)/fdimage bs=1024 count=2880
 	MTOOLSRC=$(obj)/mtools.conf mformat w:			; sync
@@ -162,6 +165,7 @@ fdimage288: $(obj)/bzImage $(obj)/mtools.conf
 	fi
 	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage w:linux	; sync
 
+.PHONY: isoimage
 isoimage: $(obj)/bzImage
 	-rm -rf $(obj)/isoimage
 	mkdir $(obj)/isoimage
@@ -183,6 +187,7 @@ isoimage: $(obj)/bzImage
 	isohybrid $(obj)/image.iso 2>/dev/null || true
 	rm -rf $(obj)/isoimage
 
+.PHONY: bzlilo
 bzlilo: $(obj)/bzImage
 	if [ -f $(INSTALL_PATH)/vmlinuz ]; then mv $(INSTALL_PATH)/vmlinuz $(INSTALL_PATH)/vmlinuz.old; fi
 	if [ -f $(INSTALL_PATH)/System.map ]; then mv $(INSTALL_PATH)/System.map $(INSTALL_PATH)/System.old; fi
@@ -190,6 +195,7 @@ bzlilo: $(obj)/bzImage
 	cp System.map $(INSTALL_PATH)/
 	if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
 
+.PHONY: install
 install:
 	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(obj)/bzImage \
 		System.map "$(INSTALL_PATH)"
-- 
1.8.1.2



