Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3GXSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:36:43 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41911 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:36:42 -0400
Message-ID: <51F01EB2.9060802@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:36:34 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: [PATCH 2/8] Mark powerpc memory resources as busy
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-5490-0000-0000-000003E0F285
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory I/O resources need to be marked as busy or else we cannot remove
them when doing memory hot remove.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/powerpc/mm/mem.c
===================================================================
--- linux.orig/arch/powerpc/mm/mem.c
+++ linux/arch/powerpc/mm/mem.c
@@ -523,7 +523,7 @@ static int add_system_ram_resources(void
 			res->name = "System RAM";
 			res->start = base;
 			res->end = base + size - 1;
-			res->flags = IORESOURCE_MEM;
+			res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 			WARN_ON(request_resource(&iomem_resource, res) < 0);
 		}
 	}

