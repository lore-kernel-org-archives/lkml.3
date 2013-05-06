Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab3EFUtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:49:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab3EFUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:47:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dros Adamson <Weston.Adamson@netapp.com>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 109/115] Give the OID registry file module info to avoid kernel tainting
Date: Mon,  6 May 2013 13:45:45 -0700
Message-Id: <20130506203106.762487438@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 9e6879460c8edb0cd3c24c09b83d06541b5af0dc upstream.

Give the OID registry file module information so that it doesn't taint the
kernel when compiled as a module and loaded.

Reported-by: Dros Adamson <Weston.Adamson@netapp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/oid_registry.c |    5 +++++
 1 file changed, 5 insertions(+)

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


