Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaDORjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:39:17 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:35245 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaDORjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:39:16 -0400
Date: Tue, 15 Apr 2014 12:39:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: percpu: Replace __get_cpu_var with this_cpu_ptr
Message-ID: <alpine.DEB.2.10.1404151238340.27545@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One case of using __get_cpu_var in the get_cpu_var macro
for address calculation.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2014-04-14 13:24:54.669364001 -0500
+++ linux/include/linux/percpu.h	2014-04-14 13:24:54.661364156 -0500
@@ -29,7 +29,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))

 /*
  * The weird & is necessary because sparse considers (void)(var) to be
