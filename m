Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab3HMTpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:45:05 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10145 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab3HMTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:45:03 -0400
Message-ID: <1376423094.32758.1.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] hugepage: mention libhugetlbfs in doc
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>, davidlohr@hp.com
Date: Tue, 13 Aug 2013 12:44:54 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Explicitly mention/recommend using the libhugetlbfs test cases
when changing related kernel code. Developers that are unaware
of the project can easily miss this and introduce potential
regressions that may or may not be caught by community review.

Also do some cleanups that make the document visually easier to
view at a first glance.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 Documentation/vm/hugetlbpage.txt | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index 4ac359b..bdd4bb9 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -165,6 +165,7 @@ which function as described above for the default huge page-sized case.
 
 
 Interaction of Task Memory Policy with Huge Page Allocation/Freeing
+===================================================================
 
 Whether huge pages are allocated and freed via the /proc interface or
 the /sysfs interface using the nr_hugepages_mempolicy attribute, the NUMA
@@ -229,6 +230,7 @@ resulting effect on persistent huge page allocation is as follows:
    of huge pages over all on-lines nodes with memory.
 
 Per Node Hugepages Attributes
+=============================
 
 A subset of the contents of the root huge page control directory in sysfs,
 described above, will be replicated under each the system device of each
@@ -258,6 +260,7 @@ applied, from which node the huge page allocation will be attempted.
 
 
 Using Huge Pages
+================
 
 If the user applications are going to request huge pages using mmap system
 call, then it is required that system administrator mount a file system of
@@ -296,20 +299,16 @@ calls, though the mount of filesystem will be required for using mmap calls
 without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
 map_hugetlb.c.
 
-*******************************************************************
+Examples
+========
 
-/*
- * map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
- */
+1) map_hugetlb: see tools/testing/selftests/vm/map_hugetlb.c
 
-*******************************************************************
+2) hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
 
-/*
- * hugepage-shm:  see tools/testing/selftests/vm/hugepage-shm.c
- */
+3) hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
 
-*******************************************************************
-
-/*
- * hugepage-mmap:  see tools/testing/selftests/vm/hugepage-mmap.c
- */
+4) The libhugetlbfs (http://libhugetlbfs.sourceforge.net) library provides a
+   wide range of userspace tools to help with huge page usability, environment
+   setup, and control. Furthermore it provides useful test cases that should be
+   used when modifying code to ensure no regressions are introduced.
-- 
1.7.11.7



