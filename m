Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3KGQ3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:29:21 -0500
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:41821 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab3KGQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:29:17 -0500
Date: Thu, 7 Nov 2013 16:29:15 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andreas Herrmann <andreas.herrmann@calxeda.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
In-Reply-To: <alpine.DEB.2.02.1311071008010.22533@gentwo.org>
Message-ID: <000001423365730f-486d720c-11cd-4f7d-939b-8ff2860c60b7-000000@email.amazonses.com>
References: <20131106184529.GB5661@alberich> <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com> <20131106195417.GK5661@alberich> <20131106203429.GL5661@alberich> <20131106211604.GM5661@alberich>
 <000001422f59e79e-ba0d30e2-fe7d-4e6f-9029-65dc5978fe60-000000@email.amazonses.com> <20131107082732.GN5661@alberich> <20131107084129.GP5661@alberich> <alpine.DEB.2.02.1311071008010.22533@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.02.1311071028282.22533@gentwo.org>
X-SES-Outgoing: 2013.11.07-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is still something not optimal with the patch since it would disable
debuggin on the kmalloc stack. Ccheck name for NULL only if
slub_debug_slabs.


Subject: slub: Handle NULL parameter in kmem_cache_flags V2

V1->V2
 - flags need to be applied regardless if !slub_debug_slabs

kmem_cache_flags may be called with NULL parameter during early boot.
Skip the test in that case.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-11-07 10:25:49.669706521 -0600
+++ linux/mm/slub.c	2013-11-07 10:27:49.130394661 -0600
@@ -1217,8 +1217,8 @@ static unsigned long kmem_cache_flags(un
 	/*
 	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (slub_debug && (!slub_debug_slabs ||
-		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
+	if (slub_debug && (!slub_debug_slabs || (name &&
+		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs)))))
 		flags |= slub_debug;

 	return flags;
