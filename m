Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbAMVYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:24:33 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54319 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbAMVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:24:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dhowells@redhat.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mmarek@suse.cz
Subject: [PATCH] X.509: shut up about included cert for silent build
Date: Tue, 13 Jan 2015 22:24 +0100
Message-ID: <2124221.xG51kBCe6s@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zH/Y2nQv5p3Iv+or/8EcmmTEl2IKWGWMky5nDNbb55TGyKSTy/Z
 43eEe03wPL6wBnrVR4Lg/pHtDSzaz4EZxhsSgwVMFezAat8yOHf0EzBymrYj+Un0l11yFH3
 kBf59zCwpLUEkacLNFixVfMP3AY5LOdTwkRxGhj0f0KF1d2H7yg/+oUFTPgstU9DbUbUIaW
 kNBOoEaEZR4+LTIOlsDCw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every kernel build that includes X.509 support prints out
a message like

 - Including cert signing_key.x509

This may be useful for some cases, but when doing automated
build tests, it just means noise.

To hide the message, this uses '$(kecho)' for printing the
message, which means we still see it when building with V=1,
but not at the normal level or when building with 'make -s'.

Signed-off-by: Arnd Bergmann <arnd@arnd.de>

diff --git a/kernel/Makefile b/kernel/Makefile
index 6892723681d5..4e5598689058 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -144,7 +144,7 @@ endif
 kernel/system_certificates.o: $(obj)/x509_certificate_list
 
 quiet_cmd_x509certs  = CERTS   $@
-      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@ $(foreach X509,$(X509_CERTIFICATES),; echo "  - Including cert $(X509)")
+      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@ $(foreach X509,$(X509_CERTIFICATES),; $(kecho) "  - Including cert $(X509)")
 
 targets += $(obj)/x509_certificate_list
 $(obj)/x509_certificate_list: $(X509_CERTIFICATES) $(obj)/.x509.list

