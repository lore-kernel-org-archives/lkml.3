Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3LMPpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab3LMPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:45:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/4] KEYS: Remove files generated when
 SYSTEM_TRUSTED_KEYRING=y
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: Kirill Tkhai <tkhai@yandex.ru>, dhowells@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2013 15:45:23 +0000
Message-ID: <20131213154523.3155.71636.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131213154508.3155.20275.stgit@warthog.procyon.org.uk>
References: <20131213154508.3155.20275.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <tkhai@yandex.ru>

Always remove generated SYSTEM_TRUSTED_KEYRING files while doing make mrproper.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c23bb0b30293..bc010ee272b6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -165,9 +165,9 @@ $(obj)/x509_certificate_list: $(X509_CERTIFICATES) $(obj)/.x509.list
 targets += $(obj)/.x509.list
 $(obj)/.x509.list:
 	@echo $(X509_CERTIFICATES) >$@
+endif
 
 clean-files := x509_certificate_list .x509.list
-endif
 
 ifeq ($(CONFIG_MODULE_SIG),y)
 ###############################################################################

