Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385Ab3E1Obm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123Ab3E1Obj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:31:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/4] MN10300: ASB2305's PCI code needs the definition of
 XIRQ1
To: torvalds@linux-foundation.com
From: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Ken Cox <jkc@redhat.com>
Date: Tue, 28 May 2013 15:31:37 +0100
Message-ID: <20130528143137.9479.67414.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130528143122.9479.49715.stgit@warthog.procyon.org.uk>
References: <20130528143122.9479.49715.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code for PCI in the ASB2305 needs the definition of XIRQ1 from proc/irq.h
otherwise the following error appears:

arch/mn10300/unit-asb2305/pci.c: In function 'unit_pci_init':
arch/mn10300/unit-asb2305/pci.c:481: error: 'XIRQ1' undeclared (first use in this function)
arch/mn10300/unit-asb2305/pci.c:481: error: (Each undeclared identifier is reported only once
arch/mn10300/unit-asb2305/pci.c:481: error: for each function it appears in.)

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ken Cox <jkc@redhat.com>
---

 arch/mn10300/unit-asb2305/pci.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 6dce9fc..8ffb80f 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -18,6 +18,7 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <asm/io.h>
+#include <asm/irq.h>
 #include "pci-asb2305.h"
 
 unsigned int pci_probe = 1;

