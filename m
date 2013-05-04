Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3EDHsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:48:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700Ab3EDHsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:48:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Give the OID registry file module info to avoid kernel
 tainting
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-nfs@vger.kernel.org, Dros Adamson <Weston.Adamson@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 04 May 2013 08:48:27 +0100
Message-ID: <20130504074827.21933.61711.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give the OID registry file module information so that it doesn't taint the
kernel when compiled as a module and loaded.

Reported-by: Dros Adamson <Weston.Adamson@netapp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: stable@vger.kernel.org
cc: linux-nfs@vger.kernel.org
---

 lib/oid_registry.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index d8de11f..318f382 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/export.h>
 #include <linux/oid_registry.h>
 #include <linux/kernel.h>
@@ -16,6 +17,10 @@
 #include <linux/bug.h>
 #include "oid_registry_data.c"
 
+MODULE_DESCRIPTION("OID Registry");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
 /**
  * look_up_OID - Find an OID registration for the specified data
  * @data: Binary representation of the OID

