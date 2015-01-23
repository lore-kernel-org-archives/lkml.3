Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbbAWViH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:38:07 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:37357 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbbAWVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:37:39 -0500
Message-Id: <20150123213735.817839692@linux.com>
Date: Fri, 23 Jan 2015 15:37:30 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [RFC 3/3] Array alloc test code
References: <20150123213727.142554068@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=array_alloc_test
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some simply throw in thing that allocates 100 objects and frees them again.

Spews out complaints about interrupts disabled since we are in an initcall.
But it shows that it works.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -5308,6 +5308,22 @@ static int __init slab_sysfs_init(void)
 
 	mutex_unlock(&slab_mutex);
 	resiliency_test();
+
+	/* Test array alloc */
+	{
+		void *arr[100];
+		int nr;
+
+		printk(KERN_INFO "Array allocation test\n");
+		printk(KERN_INFO "---------------------\n");
+		printk(KERN_INFO "Allocation 100 objects\n");
+		nr = kmem_cache_alloc_array(kmem_cache_node, GFP_KERNEL, 100, arr);
+		printk(KERN_INFO "Number allocated = %d\n", nr);
+		printk(KERN_INFO "Freeing the objects\n");
+		kmem_cache_free_array(kmem_cache_node, 100, arr);
+		printk(KERN_INFO "Array allocation test done.\n");
+	}
+
 	return 0;
 }
 

